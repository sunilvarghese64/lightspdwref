// This file contains your Data Connector logic
section lightspdwref;

token_uri = "https://cloud.lightspeedapp.com/oauth/access_token.php";
test_api_url = "https://api.lightspeedapp.com/API/Account/213740/Customer.json";
client_id = "1086246737002caed422d79796b70f8dc8b072f8c5d653b6d5d0933446d776b1";
client_secret = "4d2a96a187046963d548823f811fcd57a421fcbf33b251bcd2c213a4355a750b";
refresh_token = "8d224957c0bdcd664c6662870dc77b7bf17fc2de";

[DataSource.Kind="lightspdwref", Publish="lightspdwref.Publish"]
shared lightspdwref.Contents = (optional message as text) =>
    let
        _message = if (message <> null) then message else "(no message)",
        a = "Hello from lightspdwref: " & _message,

        queryString = [
                        refresh_token = refresh_token,
                        client_secret = client_secret,
                        client_id = client_id,
                        grant_type = "refresh_token"
        ],
       // queryWithCode = Record.AddField(queryString),

        tokenResponse = Web.Contents(token_uri, [
            Content = Text.ToBinary(Uri.BuildQueryString(queryString)),
            Headers = [
                #"Content-type" = "application/x-www-form-urlencoded",
                #"Accept" = "application/json"
            ],
            ManualStatusHandling = {400} 
        ]),
        body = Json.Document(tokenResponse),

     //  convertedtotable = body["access_token"]




        acctkn = if (Record.HasFields(body, {"error", "error_description"})) then 
                    error Error.Record(body[error], body[error_description], body)
                 else
                    Record.ToTable(body){0}[Value]



        
    in
        result;


// Data Source Kind description
lightspdwref = [
    Authentication = [
        // Key = [],
        // UsernamePassword = [],
        // Windows = [],
        Implicit = []
    ],
    Label = Extension.LoadString("DataSourceLabel")
];

// Data Source UI publishing description
lightspdwref.Publish = [
    Beta = true,
    Category = "Other",
    ButtonText = { Extension.LoadString("ButtonTitle"), Extension.LoadString("ButtonHelp") },
    LearnMoreUrl = "https://powerbi.microsoft.com/",
    SourceImage = lightspdwref.Icons,
    SourceTypeImage = lightspdwref.Icons
];

lightspdwref.Icons = [
    Icon16 = { Extension.Contents("lightspdwref16.png"), Extension.Contents("lightspdwref20.png"), Extension.Contents("lightspdwref24.png"), Extension.Contents("lightspdwref32.png") },
    Icon32 = { Extension.Contents("lightspdwref32.png"), Extension.Contents("lightspdwref40.png"), Extension.Contents("lightspdwref48.png"), Extension.Contents("lightspdwref64.png") }
];
