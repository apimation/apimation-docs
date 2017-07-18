# Apimation YAML test scenario creation documentation

#### Test assets in yaml must be categorized in following:
- all test cases should be saved in folder 'cases'
- all test steps should be saved in folder 'steps'
- all load test scenarios can be saved in any folder name

Steps can be defined either in test case yaml list section 'steps' or in dedicated step yaml file
If step is defined in step yaml then in test case it is enough to declare its 'name', 'collection name' and 'load: true', to overwrite any of step details for the test case you can use 'overwrite: true' and just redefine the needed detail


### Legend
*optional parameters are marked with: [optional]*

## Test case yaml doc
```ruby
name: string `Name label of test case`
setName: string `Name label of test set`
description: string `Description of test case` [optional]
save: boolean `true by default, set to false if test case does not need to be saved in the cloud` [optional]
overwrite: boolean `true by default, set to false if test case does not need to be overwritten in the cloud` [optional]
casedetails: `Case details is a dictionary which holds all the test case data`
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
type: ("x-www-form-urlencoded"|"form-data"|"raw"|"binary") `Type of http body, mandatory for POST method`
#Depending on body type use the according content
#if type=="x-www-form-urlencoded"
urlEncParams: `Dictionary of url encoded parameters`
    (paramname:string): (paramvalue:string|int)
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
        srcPath: string `xpath or jsonpath depending on type`
        dstVar: string `apimation variable name in which the list of filtered values will be saved, the list value is jsarray`
        srcField: string `node property name to filter by`
        operator: ("eq"|"ne"|"gt"|"lt"|"ge"|"le"|"regex") `operator values`
        expected: string `expected value to compare the srcField to`
        resultField: string `node property to extract and save into the list if the condition is true`
asserts: `List of assertions`
    -   key: string `depends on type, see greps section expression property`
        type: ("json"|"xml"|"text"|"headers"|"status"|"rtt"|"rsize"|"custom") `custom type is to compare any string variable to expected value, for other types see grep type section`
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