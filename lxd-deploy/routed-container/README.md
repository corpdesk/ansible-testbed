

# Get Started
- config file
- .env file
- npm start
``` 

cd "$HOME/ansible-testbed/lxd-deploy/routed-container/"
sh cd-db-91-container.sh
sh cd-api-92-container.sh
sh cd-sio-93-container.sh
sh cd-web-94-container.sh
#Curl Request:
curl -k -X POST -H 'Content-Type: application/json' -d '{ "ctx": "Sys", "m": "User", "c": "User", "a": "Login", "dat": { "f_vals": [ { "data": { "userName": "karl", "password": "secret", "consumerGuid": "B0B3DA99-1859-A499-90F6-1E3F69575DCD" } } ], "token": null }, "args": null }' https://cd-api-92:3001 -v
//////////////////////////////
curl 
-k 
-X 
POST 
-H 'Content-Type: application/json' 
-H 'anon:0' 
-H 'p_sid:goqes5rof9i8tcvrv341krjld8' 
-H 'sess_ttl:10' 
-H 'token:2DC1B60A-4361-A274-ACB5-622C842B545C' 
-d '
{
    "m": "moduleman",
    "c": "cd_cache",
    "a": "read",
    "dat": {
        "fields": ["content_id", "user_id", "content"],
        "filter": {
            "content_id": "moduleman_ModulesController_GetModuleUserData_156_1010",
            "user_id": "1010"
        },
        "token": "CADFE0DB-342F-C8DB-6EAA-7CDDE9621C52",
        "p_sid": "s3n39am5n3l18lskvast7v5t99",
        "sess_ttl": "10",
        "init_ctx": "login"
    },
    "args": {
        "doc_from": "",
        "doc_to": "",
        "subject": "read cd_accts_bank",
        "doctyp_id": ""
    }
}
' https://corpdesk.net:3004/sys 
-v
*/

```