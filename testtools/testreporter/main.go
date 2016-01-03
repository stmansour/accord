// This program is only needed on the jenkins machine.

package main

// This package is devoted to handling the environment descriptor
// and managing its resources.

import (
	"encoding/json"
	"flag"
	"fmt"
	"io/ioutil"
	"os"
	"strings"
)

const (
	uUNKNOWN = iota
	uINIT
	uREADY
	uTEST
	uDONE
	uTERM
)

// KeyVal is a generic key/value pair struct
type KeyVal struct {
	Key string
	Val string
}

// AppDescr is an application description that provides information
// about an application that we deploy.
type AppDescr struct {
	UID    string
	Name   string
	Repo   string
	UPort  int
	IsTest bool
	State  int
	RunCmd string // if present overrides "activate.sh startr"
	KVs    []KeyVal
}

// ResourceDescr is a structure of data defining what optional resources
// each instance needs.
type ResourceDescr struct {
	MySQL bool // if true, MySQL will be started
}

// InstDescr is a structure of data describing every Instance (virtual
// computer) that we deploy in the cloud
type InstDescr struct {
	InstName  string
	OS        string
	HostName  string
	InstAwsID string
	Resources ResourceDescr
	Apps      []AppDescr
}

// EnvDescr is a struct that defines a test (or production) environment.
type EnvDescr struct {
	EnvName   string      // the name associated with the collection of Instances
	UhuraURL  string      // the http url where tgo instances should contact uhura
	UhuraPort int         // (may not be needed) is the port on which uhura listens. Default is 8100
	ThisInst  int         // informs a tgo instance which Instance index it is. Basically ignored within uhura
	State     int         // overall state of the environment
	Instances []InstDescr // the array of InstDescr describing each instance in the env.
}

//  The main data object for this module
var UEnv *EnvDescr

type testRpt struct {
	envDescr string
	urlReq   string
	report   bool
}

// TestReporter is the program data struct
var TestReporter testRpt

// OK, this is a major cop-out, but not sure what else to do...
func check(e error) {
	if e != nil {
		panic(e)
	}
}

// This is uhura's standard logger
func ulog(format string, a ...interface{}) {
	p := fmt.Sprintf(format, a...)
	fmt.Print(p)
}

// BuildReport reads the json result file from uhura and generates a summary report
func BuildReport() {
	if !TestReporter.report {
		return
	}

	var results string
	var tests int
	var pass int
	var fail int

	fmt.Printf("TEST RESULTS\n")
	for i := 0; i < len(UEnv.Instances); i++ {
		for j := 0; j < len(UEnv.Instances[i].Apps); j++ {
			if UEnv.Instances[i].Apps[j].IsTest {
				tests++
				for k := 0; k < len(UEnv.Instances[i].Apps[j].KVs); k++ {
					if UEnv.Instances[i].Apps[j].KVs[k].Key == "testresults" {
						results = UEnv.Instances[i].Apps[j].KVs[k].Val
						if strings.ToLower(results) == "pass" {
							pass++
						} else {
							fail++
						}
					}
				}
				fmt.Printf("%s.%s[%s]: %s\n", UEnv.Instances[i].InstName, UEnv.Instances[i].Apps[j].UID, UEnv.Instances[i].Apps[j].Name, results)
			}
		}
	}
	fmt.Printf("Total tests:      %d\n", tests)
	fmt.Printf("Total tests pass: %d\n", pass)
	fmt.Printf("Total tests fail: %d\n", fail)
}

// PrintURL looks at the Instance and App supplied on the command line
// and prints an http url to the host and port
func PrintURL() {
	if len(TestReporter.urlReq) > 0 {
		// format is like "phone,phonebook"
		sa := strings.Split(TestReporter.urlReq, ",")
		sa[0] = strings.ToLower(strings.Trim(sa[0], " \r\n"))
		sa[1] = strings.ToLower(strings.Trim(sa[1], " \r\n"))
		for i := 0; i < len(UEnv.Instances); i++ {
			if sa[0] == strings.ToLower(UEnv.Instances[i].InstName) {
				for j := 0; j < len(UEnv.Instances[i].Apps); j++ {
					if sa[1] == UEnv.Instances[i].Apps[j].Name {
						fmt.Printf("http://%s:%d/\n", UEnv.Instances[i].HostName, UEnv.Instances[i].Apps[j].UPort)
						return
					}
				}
			}
		}
	}
}
func loadEnvDescriptor(fname string) {
	content, e := ioutil.ReadFile(fname)
	if e != nil {
		ulog("File error loading %s: %v\n", fname, e)
		os.Exit(1) // no recovery from this
	}

	// OK, now we have the json describing the environment in content (a string)
	// Parse it into an internal data structure...
	err := json.Unmarshal(content, &UEnv)
	if err != nil {
		ulog("Error unmarshaling Environment Descriptor json: %s\n", err)
		check(err)
	}
}

func processCommandLine() {
	fPtr := flag.String("f", "EnvShutdownStatus.json", "file name to process")
	uPtr := flag.String("u", "", "supply: InstanceName,AppName  -- it prints the URL to the host:port")
	uRpt := flag.Bool("r", false, "Generates test results report")
	flag.Parse()
	TestReporter.envDescr = *fPtr
	TestReporter.urlReq = *uPtr
	TestReporter.report = *uRpt
}

func main() {
	processCommandLine()
	loadEnvDescriptor(TestReporter.envDescr)
	BuildReport()
	PrintURL()
}
