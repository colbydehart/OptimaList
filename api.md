- /token POST
    "username"
    "password" 

- /register POST
    "username" any name
    "email" email, will be referred in the token request
    "password" 

- /recipes GET
    list of user's recipes

- /recipes POST
    posts a recipe and creates ingredients accordingly
    "recipe" : {
        "name" recipes name,
        "url" the website
    }
    "ingredients": [
        {
            "name"
            "quantity"
            "measurement"
        }
    ]


- /list GET [?rate=3]
    create optimal list
    "recipes": [
        {"name", "url"}
    ]
    "ingredients": [
        {"{name}": {"mass", "volume", "unit"}}
        //eg {"potato" : {"volume": "2" }
    ]