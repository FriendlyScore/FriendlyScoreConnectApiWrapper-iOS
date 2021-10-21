FriendlyScore Connect API Wrapper allows you build custom UX to connect bank accounts by using FriendlyScore REST API.

#### **Steps**

1. Get access token

    
    Your server must use `client_id` and `client_secret` to authorize itself with the FriendlyScore Servers.

    The successful completion of authorization request will provide you with access_token.

    This access_token is required to generate a userToken to make user related requests.

    Your app must ask your server for the `access_token`

    `DO NOT` put your `client_secret` in your mobile app.
    
&nbsp;
&nbsp;

2. Create the `FriendlyScoreClient`

    Choose the `client_id` and the environment you want to integrate. You can access the `client_id` from the FriendlyScore panel

        
        var  environment: Environment = Environment.SANDBOX
        var client_id: String = "YOUR_CLIENT_ID"
        var access_token: String = "access_token_from_step_1"

        var fsClient: FriendlyScoreClient  = FriendlyScoreClient(environment: environment, clientId: client_id, accessToken: access_token)
     

    The `fsClient` will be required to make other requests 

&nbsp;
&nbsp;

3. Create User Token

    You must create `userToken` in order to make any request for the user.

    In order to receive response you must implement closures `requestSuccess`, `requestFailure`, `otherError`.
    
    `requestSuccess` - if the status code is between [200,300). Response type `UserToken`

    `requestFailure` - if the status code is between [300,500]. Response type `MoyaResponse`

    `otherError` - Any other error such as timeout or unexpected error. Response type `Swift.Error?`

    &nbsp;
    &nbsp;
    #### **Required parameters:** 
    `fsClient` - FriendlyScoreClient

    `user_reference` - Unique user reference that identifies user in your systems.

    
        
        var userReference: String = "user_reference"
        
        fsClient?.createUserAuthToken(userReference: userReference, 
            requestSuccess: { userToken in
                self.userToken = userToken.getToken()
            }, 
            requestFailure: { moyaResponse in
                let statusCode = moyaResponse.statusCode
                let data: Data = moyaResponse.data                 
            }, 
            otherError: { error in
                print(error.debugDescription)
            } 
        )
    Use the `fsClient` to make the requests

    
&nbsp;
&nbsp;

4. Get List of Banks

    You can obtain the list of banks for the user

    In order to receive response you must implement closures `requestSuccess`, `requestFailure`, `otherError`.
    
    `requestSuccess` - if the status code is between [200,300). Response type `ArrayList<UserBank>`

    `requestFailure` - if the status code is between [300,600). Response type `MoyaResponse`

    `otherError` - Any other error such as timeout or unexpected error. Response type `Swift.Error?`

    &nbsp;
    &nbsp;
    #### **Required parameters:** 

    `fsClient` - FriendlyScoreClient

    `userToken` - User Token obtained from authorization endpoint

        var userToken: String = "User Token obtained from authorization endpoint"

        fsClient?.fetchBankList(userToken: userToken, 
                requestSuccess: { bankList in
                    
                }, 
                requestFailure: { moyaresponse in
                    let statusCode = moyaResponse.statusCode
                    let data: Data = moyaResponse.data  

                }, 
                otherError: { error in
                    print(error.debugDescription)
                }
        )
    

    The important values for each bank that will be required for the ui and future requests. For example, for the first bank in the list, we show the important values:

    
            //Slug is Unique per bank
            String bankSlug = bankList.get(0).bank.slug;
            //Bank Name
            String bankName = bankList.get(0).bank.name;
            //Bank Logo Url
            String bankLogoUrl = bankList.get(0).bank.logo_url;
            //Bank CountryCode
            String bankCountryCode = bankList.get(0).bank.country_code;
            //Bank Type {Personal, Business}
            String type = bankList.get(0).bank.type;
            //Number of months in the past, data for this bank can be accessed from
            long numberOfMonthsInPast  = bankList.get(0).bank.bank_configuration.transactions_consent_from;
            //Number of months in the future, data for this bank will be available for
            long numberOfMonthsInFuture bankList.get(0).bank.bank_configuration.transactions_consent_to;
            // Status if the user has connected the with an account at the bank
            Boolean connectedBank = bankList.get(0).connected
            //The flag when true indicates the bank APIs status are
            Boolean isActive = bankList.get(0).bank.is_active
            //Accounts for the user, if the user has connected the account
            ArrayList<BankAccount> bankAccountList = bankList.get(0).accounts;



&nbsp;
&nbsp;

5. Get Bank Consent Screen Information

    Once the user has selected a bank from the list. You must show the user the necessary information as required by the law.

    In order to receive response you must implement closures `requestSuccess`, `requestFailure`, `otherError`.
    
    `requestSuccess` - if the status code is between [200,300). Response type `Data`

    `requestFailure` - if the status code is between [300,600). Response type `MoyaResponse`

    `otherError` - Any other error such as timeout or unexpected error. Response type `Swift.Error?`

    Make this request 
    
        a. to create the consent screen using the required and regulated information for the bank the user selected

    &nbsp;
    &nbsp;
    #### **Required parameters:** 


    `fsClient` - FriendlyScoreClient
        
    `userToken` - User Token obtained from authorization endpoint
        
    `bankSlug` - Slug for the bank user has selected from the list of banks
        
    `screenType` - consent_screen
        
    `state` - UUID string, unique per request

    Save the `bankSlug` and `state`, it is required to generate the Url to start bank authorization flow
         
    &nbsp;
    &nbsp;
    
            var userToken: String = "User Token obtained from authorization endpoint"
            var bankSlug: String = "Slug for the bank user has selected from the list of banks"
            var screenType: String = "consent_screen"
            var state: String = "UUID String"

            fsClient?.fetchBankList(userToken: userToken, slug: bankSlug, screenType: screenType, state: state>, 
                requestSuccess: { consentScreenJson in
                    
                }, 
                requestFailure: { moyaresponse in
                    let statusCode = moyaResponse.statusCode
                    let data: Data = moyaResponse.data  

                }, 
                otherError: { error in
                    print(error.debugDescription)
                }
        )

    
&nbsp;
&nbsp;

6. Get Bank Flow Url
    
    Make this request from the consent screen after the user has seen all the information that will is being requested.
    
    You must make this request to get the url to open the Bank Flow for users to authorize access account information

    In order to receive response you must implement closures `requestSuccess`, `requestFailure`, `otherError`.
    
    `requestSuccess` - if the status code is between [200,300). Response type `BankFlowUrl`

    `requestFailure` - if the status code is between [300,600). Response type `MoyaResponse`

    `otherError` - Any other error such as timeout or unexpected error. Response type `Swift.Error?`
    
    &nbsp;
    &nbsp;
    #### **Required parameters:** 


    `fsClient` - FriendlyScoreClient
        
    `userToken` - User Token obtained from authorization endpoint
        
    `bankSlug` - Slug for the bank user has selected from the list of banks
                
    `state` - UUID string, must be the same value from the previous request
        
    `dateFrom` - Time stamp in seconds

    `dateTo` - Time stamp in seconds
         
    &nbsp;
    &nbsp;
    
            var userToken: String = "User Token obtained from authorization endpoint"
            var bankSlug: String = "Slug for the bank user has selected from the list of banks"
            var dateFrom: Int64 =  1560693223
            var dateTo: Int64 = 1631800423
    
        fsClient?.fetchBankFlowUrl(userToken: userToken, slug: bankSlug, dateFrom: dateFrom, dateTo: dateTo, state: state,
                requestSuccess: { bankFlowUrl in
                    
                }, 
                requestFailure: { moyaresponse in
                    let statusCode = moyaResponse.statusCode
                    let data: Data = moyaResponse.data  

                }, 
                otherError: { error in
                    print(error.debugDescription)
                }
        )
    


    From `BankFlowUrl` extract the `url` value and trigger it to start the authorization process with the bank


&nbsp;
&nbsp;


7. Redirect back to the app

    The user is redirected back to your app after a user successfully authorizes, cancels the authorization process or any other error during the authorization.

    &nbsp;
    &nbsp;

    Your app must handle redirection for

    &nbsp;
    &nbsp;

    `/openbanking/code` - successful authorization by user. It should have 2 parameters. `code` and `state`

    &nbsp;
    &nbsp;

    `/openbanking/error` - error in authorization or user did not complete authorization. It should have 2 parameters. `error` and `state`


&nbsp;
&nbsp;

8. Delete Account Consent

    Make this request to allow the user to delete consent to access account information.


    In order to receive response you must implement closures `requestSuccess`, `requestFailure`, `otherError`.
    
    `requestSuccess` - if the status code is between [200,300). Response type `Void`

    `requestFailure` - if the status code is between [300,600). Response type `MoyaResponse`

    `otherError` - Any other error such as timeout or unexpected error. Response type `Swift.Error?`

    &nbsp;
    &nbsp;

    #### **Required parameters:** 
    `fsClient` - FriendlyScoreClient

    `userToken` - User Token obtained from authorization endpoint
        
    `bankSlug` - Slug for the bank


        fsClient?.deleteBankConsent(userToken: userToken, slug: bankSlug,
                requestSuccess: { _ in
                    
                }, 
                requestFailure: { moyaresponse in
                    let statusCode = moyaResponse.statusCode
                    let data: Data = moyaResponse.data  

                }, 
                otherError: { error in
                    print(error.debugDescription)
                }
        )
