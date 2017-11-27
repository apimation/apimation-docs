# Apimation function calls

Apimation function calls cam be used anywhere data needs to be either generated either processed and apimation team is open to adding new function call features on request

### Note:
- new function call requests should be directly addressed to support@apimation.com (usual time of request processing: 24 hours)
- function call description is in regular expression string and example is given

## Data generation

- Generate email string, length as argument: `\$genEmail\(\d*\)` $genEmail(10)
- Generate string, length as argument: `\$genString\(\d*\)` $genString(30)
- Generate string from subset of characters: `\$genStringFromSubset\((\d+),\s*(.*?)\)` $genStringFromSubset(10,abcdef)

## Data manipulation

- Return current time in Unix, epoch format (in seconds): `\$epochTimeInSeconds\(\)` $epochTimeInSeconds()
- Convert date to epoch, date string as argument: `\$dateToEpoch\((.*?)\)`  $dateToEpoch(2006-01-02T15:04:05.000Z)
Available date strings:
"2006-01-02T15:04:05.000Z",
"Mon, 02 Jan 2006 15:04:05 +0000",
"Mon Jan 2 15:04:05 +0000 MST 2006"
- JWT (jason web token) validation:  `\$jwtValidate\(([\w$]*?)[,\)]([\w$]*)\)*` $jwtValidate($jwtString, $hmacSecretString)
- Return length of a json array saved in apimation variable: `\$len\((.*?)\)` $len($jsonList)

## Request specific data manipulation

- Generate HMAC `\$generateHMACFromRequest\(([\w$]*?)[,\)]([\w$]*?)[,\)]([\w$]*?)[,\)]([\w$]*)\)*` $generateHMACFromRequest(algorithm, encoding, key, nonce)
Accepted algorithms: sha256
Accepted encodings: base64
