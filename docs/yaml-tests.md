# Apimation YAML test scenario creation documentation

```ruby
name: string `Name label of test case`
setName: string `Name label of test set`
description: string `Description of test case`
save: boolean `true by default, set to false if test case does not need to be saved in the cloud`
overwrite: boolean `true by default, set to false if test case does not need to be overwritten in the cloud`
casedetails: `Case details is a dictionary which holds all the test case data`
    vars: `Dictionary of apimation variables where the key is varname starting with '$' and the value is variable value`
        (varname:string): (varvalue:string|int)
        ...
    loop: `List of loop conditions for a range or single unit of steps`
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
                    type: ("json"|"xml"|"text"|"headers"|"status"|"rtt"|"rsize") `Type of extraction; json and xml will enable usage of jsonpath and xpath expressions; text type is used to extract everything that is in the response body and it is possible to use regex groups to extract specific parts of it; headers is used to get specific header value; status is used to get response status message; rtt is round trip time i.e. response time in milliseconds; rsize is response packet size in bytes`
                    expression: "$.webhook.id" `For json use jsonpath expression, for xml use xpath expression, for text use string values or regex expression with group, for headers use header name, index and regex if needed, i.e. Location[0]{http://(\d+)}, for status, rtt and rsize expression is not needed,`
                -   ...
            conditionalGreps: `conditional grep is used to filter an array of json or xml object nodes by a given node property and save each of filtered nodes expected property value into a json array list which is then saved to an apimation variable`
                -   type: ("json"|"xml") `see information on types of 'greps' property`
                    srcPath: string `xpath or jsonpath depending on type`
                    dstVar: string `apimation variable name in which the list of filtered values will be saved, the list value is json array`
                    srcField: string `node property name to filter by`
                    operator: ("eq"|"ne"|"gt"|"lt"|"ge"|"le"|"regex") `operator values`
                    expected: string `expected value to compare the srcField to`
                    resultField: string `node property to extract and save into the list if the condition is true`
            asserts: `List of assertions`
                -   key: string `depends on type, see greps section expression property`
                    type: ("json"|"xml"|"text"|"headers"|"status"|"rtt"|"rsize"|"custom") `custom type is to compare any string or variable to expected value, for other types see grep type section`
                    operator: ("eq"|"ne"|"gt"|"lt"|"ge"|"le"|"regex") `operator values`
                    expected: string `expected value`
                    description: string `description of assert`
                    jsonValueType: ("value"|"count") `only for json type: by default set to value, set to count if length comparison is needed`
            assertQuick: `shortcuts of asserts`
                status: string `Response status assertion`
                responseTime: string `Response time assertion`
            loop: `Holds step loop conditions`
                interval: int `loop interval in seconds`
                loop: boolean `set if loop is needed`
                count: int `maximum loop count`
                conditions: `loop exit conditions, has same properties as assert object`
                    -   ...
            save: boolean `true by default, set to false if step does not need to be saved into the specified collection`
            load: boolean `false by default, set to true if step needs to be loaded`
            overwrite: boolean `true by default, set to false if given step properties need not to be overwritten or else those that can be will be appended`
         -  ...
