# Apimation YAML test scenario creation documentation

#### Test assets in yaml must be categorized in following:
- all test cases should be saved under folder 'cases'
- all test steps should be saved under folder 'steps'
- all load test scenarios can be saved under any folder name
- all test environment files can be saved in any folder name, recommended to be under Environments/
- all test set files can be saved in any folder name, recommended to be under Sets/

Steps can be defined either in test case yaml list section 'steps' or in dedicated step yaml file
If step is defined in step yaml then in test case it is enough to declare its 'name', 'collection name' and 'load: true', to overwrite any of step details for the test case you can use 'overwrite: true' and just redefine the needed detail

### Legend
*optional parameters are marked with: [optional]*

## Test environment yaml doc
``` ruby
test: environment `mandatory property key and constant value to define the test yaml type as test environment`
name: string `Name label of environment, used to set test environment in cli client`
globalVars: `Dictionary which holds all the global variable data (scoped through all test cases in run)`
    (varname:string): (varvalue:string|int)
```

## Test set (test suite) yaml doc
``` ruby
test: set `mandatory property key and constant value to define the test yaml type as test set`
name: string `Name label of test set, used to trigger test set execution in cli client`
description: string `Description of test set`
cases: `list of test case names to be included in test set`
  - string
  ...
```

## Test case yaml doc
```ruby
test: case `mandatory property key and constant value to define the test yaml type as test case`
name: string `Name label of test case`
setName: string `Name label of test set`
description: string `Description of test case` [optional]
save: boolean `true by default, set to false if test case does not need to be saved in the cloud` [optional]
overwrite: boolean `true by default, set to false if test case does not need to be overwritten in the cloud` [optional]
casedetails: `Case details is a dictionary which holds all the test case data`
    jsVars: `Dictionary of apimation variables as keys and executable javascript file paths as values, always started with '$'` [optional]
        (varname:string): (varvalue:string)
    vars: `Dictionary of apimation variables where the key is varname starting with '$' and the value is variable value` [optional]
        (varname:string): (varvalue:string|int)
        ...
    loop: `List of loop conditions for a range or single unit of steps` [optional]
        -   range: string(/^(\d+-\d+)|(\d+)/)
            count: (int|"$len($jsonArr)") `Values for loop count can be either static or dynamic, use $len() function call and provide an apimation variable with json array value for the dynamic calculation` 
            listInPositions: `Dictionary with apimation variables with list of values and each of them will be used for each loop iteration`
                (varname:string): [(varvalue:string),...]
                ...
        -   ...
    steps: `List of test case steps defined. Use environment, case variables and/or function calls if needed. For example in url value: $api/books/$id`
        -   name: string `Name label of test step`
            collection:
                name: string `Name label of collection to which the step belongs (like a category)`
            load: boolean `false by default, set to true if step needs to be loaded`
        -   ...
```

## Test step yaml doc
```ruby
test: step `mandatory property key and constant value to define the test yaml type as test step`
name: string `Name label of test step`
collection:
    name: string `Name label of collection to which the step belongs (like a category)`
method: string("GET"|"POST"|"PUT"|"DELETE"|"HEAD"|"OPTIONS") `http method for the http request, if not set GET is default`
url: string `URL value for hhtp request`
queryParams: `Dictionary with query parameters`
    (paramname:string): [(paramvalue:string),...]
headers: `Dictionary of http headers`
    (headername:string): (headervalue:string)
    ...
delay: int `step execution delay after the previous step in seconds`
type: ("x-www-form-urlencoded"|"form-data"|"raw"|"binary"|"assert"|"system-cmd") `Type of step, mandatory for POST method; For non-http request steps: use 'assert' to test string/int/float assertions; use 'system-cmd' to be able to use shell scripts or system commands in 'body' property of step definition`
#Depending on body type use the according content
#if type=="x-www-form-urlencoded"
urlEncodedParams: `Dictionary of url encoded parameters`
    (paramname:string): [(paramvalue:string|int),...]
    ...
#if type=="form-data"
formData: `List of form data parameters`
    -   name: string
        value: string
        type: ("file"|"text")
        filename: string
    -   ...
#if type=="raw"
body: string `Raw body of string or multiline strings`
#if type=="binary"
binaryContent: `Binary data body option`
    value: string `Content of binary data in base64`
    filename: string
greps: `List of greps: apimation way of calling extracts from any part of the response`
    -   varname: string `name of apimation variable in which the extracted value will be saved`
        type: ("json"|"xml"|"text"|"headers"|"status"|"rtt"|"rsize") `Type of extraction; json and xml will enable usage jsonpath and xpath expressions; text type is used to extract everything that is in the response body and it possible to use regex groups to extract specific parts of it; headers is used to get specific header value; status used to get response status message; rtt is round trip time i.e. response time in milliseconds; rsize is responpacket size in bytes`
        expression: "$.webhook.id" `For json use jsonpath expression, for xml use xpath expression, for text use strivalues or regex expression with group, for headers use header name, index and regex if needed, i.e. Location{http://(\d+)}, for status, rtt and rsize expression is not needed,`
    -   ...
conditionalGreps: `conditional grep is used to filter an array of json or xml object nodes by a given node property and saeach of filtered nodes expected property value into a json array list which is then saved to an apimation variable`
    -   type: ("json"|"xml") `see information on types of 'greps' property`
        srcPath: string `xpath or jsonpath that points to the list of json or xml objects, the one that will be filtered`
        dstVar: string `apimation variable name in which the list of filtered values will be saved, the list value is jsarray`
        srcField: string `node property name to filter by`
        operator: ("eq"|"ne"|"gt"|"lt"|"ge"|"le"|"regex") `operator values`
        expected: string `expected value to compare the srcField to`
        resultField: string `node property to extract and save into the list if the condition is true`
asserts: `List of assertions`
    -   key: string `depends on type, see greps section expression property`
        type: ("json"|"xml"|"text"|"headers"|"status"|"rtt"|"rsize"|"string"|"int"|"float"|"cmd") `string, int, float types are used to compare given value in 'key' property to 'expected' property value; 'cmd' is used to assert either cmd output or exitCode, for other types see grep type section`
        operator: ("eq"|"ne"|"gt"|"lt"|"ge"|"le"|"regex") `operator values`
        expected: string `expected value`
        description: string `description of assert`
        jsonValueType: ("value"|"count") `only for json type: by default set to value, set to count if length comparison needed`
assertQuick: `shortcuts of asserts`
    status: string `Response status assertion`
    responseTime: string `Response time assertion`
loop: `Holds step loop conditions`
    interval: int `loop interval in seconds`
    loop: boolean `set if loop is needed`
    count: int `maximum loop count`
    conditions: `loop exit conditions, has same properties as assert object`
        -   ...
nostore: boolean `false by default, set to true if step does not need to be saved into the specified collection`
load: boolean `false by default, set to true if step needs to be loaded`
append: boolean `false by default, set to true if given step properties need not to be overwritten or else those step properties that are defined will be appended`
```


## Load test case yaml doc
```ruby
name: String `Name label of test load case`
loadtype: String ("simulation"|"constant")
details:
    minifiedResult: Boolean `true by default, set false if test case data is necessary to be displayed in terminal window`
    setupCases: String List ["SetupTestCaseNameLabel"] `List of name labels of test cases which must be executed before main tests`
    finalCases: String List ["FinalTestCaseNameLabel"] `List of name labels of test cases which must be executed after all test has been executed` 
    testCase: String `Name label of test case`
    environment: String `Name label of environment where tests will be executed`
    users: Int `total count of jobs to be executed for test case`
    duration: String `duration in secons (s) or minutes (m) for testcase`
    distribution: String ("random")
    workers: `list of workers`
        -   worker: String `Name label of worker`
            users: Int `count of jobs to be executed for particular worker`
        -   ...
    asserts: `List of assertions`
        -   type: String ("latency"|"wait"|"requestrate"|"requestcount"|"all200")
            #if type == "latency"
            metric: String ("max"|"mean"|"50th"|"95th"|"99th"|"total")
            #if type in ["latency", "wait"]
            expected: String `Duration in millisecons (ms), secons (s) or minutes (m)`
            #if type in ["requestrate", "requestcount"]
            expected: Int 
            #if type == "all200"
            expected: Boolean true
```