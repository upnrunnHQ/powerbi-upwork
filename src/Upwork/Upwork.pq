﻿
// This file contains Upwork connector logic
[version = "1.0.0"]
section Upwork;

windowWidth = 1024;
windowHeight = 720;

clientId = Json.Document(Extension.Contents("client_application.json"))[ClientId];
clientSecret = Json.Document(Extension.Contents("client_application.json"))[ClientSecret];
callbackUrl = Json.Document(Extension.Contents("client_application.json"))[CallbackUrl];
recordsPerPage = Json.Document(Extension.Contents("client_application.json"))[RecordsPerPage];

//Upwork base Url
baseUrl = "https://www.upwork.com";

//Upwork token Urls
requestTokenUrl = "/api/auth/v1/oauth/token/request";
authenticateUrl = "/services/api/auth";
accessTokenUrl = "/api/auth/v1/oauth/token/access";


//Upwork data APIs (relative path)
teamUrl = "/api/hr/v2/teams.json";
contractUrl = "/api/hr/v2/engagements.json";
jobUrl = "/api/hr/v2/jobs.json";
offerUrl = "/api/offers/v1/clients/offers";
jobApplicationUrl = "/api/hr/v4/clients/applications.json";

freelancePrefixUrl = "/api/profiles/v1/providers/";
freelanceSuffixUrl = "/brief.json";

billingPrefixUrl = "/gds/finreports/v2/buyer_teams/";
billingSuffixUrl = "/billings";


//Billing query
billingQuery = "SELECT SUM(amount) WHERE assignment__reference=";
billingQuery2 = "SELECT assignment__reference, SUM(amount) WHERE date>='$sdate$' and date <='$edate$'";

//Upwork public Urls
freelanceProfileUrl = "https://www.upwork.com/freelancers/";
contractProfileUrl = "https://www.upwork.com/ab/c/";

//Upwork columns to be retrieved
teamColumns = {
    "reference",
     "name",
    "company__reference",
    "company_name"   
   };

teamOutputColumns = {
    "team_id",
    "team_name",
    "company_id",
    "company_name"   
   };

teamOutputFinalColumns = {
    "team_id",
    "team_name",
    "company_id",
    "company_name",
    "server_time"
   };

teamMasterColumns = {"auth_user", "teams", "server_time"};

contractColumns = {
    "buyer_team__reference",
     "reference",
    "engagement_title",
    "engagement_job_type",
    "status",
    "cj_job_application_uid",
    "job_application_ref",
    "job_ref_ciphertext",
    "hourly_charge_rate",
    "weekly_hours_limit",
    "created_time",
    "engagement_start_date",
    "engagement_end_date",
    "provider__reference",
    "dev_recno_ciphertext",
    "provider__id",
    "provider__name",
    "provider_team__name",
    "feedback",
    "offer_id"
   };

 contractOutputColumns = {
    "buyer_team_id",
    "contract_id",
    "contract_title",
    "contract_type",
    "contract_status",
    "cj_job_application_uid",
    "job_application_ref",
    "job_text_id",
    "hourly_charge_rate",
    "weekly_hours_limit",
    "accept_date",
    "start_date",
    "end_date",
    "freelancer_id",
    "freelancer_text_id",
    "freelancer_user_id",
    "provider__name",
    "provider_team__name",
    "feedback",
    "offer_id"
   };

contractOutputFinalColumns = {
    "buyer_team_id",
    "contract_id",
    "contract_title",
    "contract_type",
    "contract_status",
    "job_text_id",
    "hourly_charge_rate",
    "weekly_hours_limit",
    "accept_date",
    "start_date",
    "end_date",
    "freelancer_id",
    "freelancer_text_id",
    "freelancer_user_id",
    "feedback_to_client_score",
    "feedback_to_freelancer_score",
    "offer_id"
   };

contractMasterColumns = {"server_time", "auth_user", "engagements"};
contractEnagementColumns = {"engagement", "lister"};


feedbackColumns = {
"feedback_for_buyer",
"feedback_for_provider"
};

jobColumns = {
    "buyer_team__reference",
    "job_ref_ciphertext",
    "reference",
    "title",
    "created_by_name",
    "status",
    "public_url",
    "category2",
    "subcategory2",
    "created_time"
};

jobOutputColumns = {
    "buyer_team__reference",
    "job_text_id",
    "job_id",
    "job_title",
    "job_created_by_name",
    "job_status",
    "job_public_url",
    "category",
    "subcategory",
    "job_created_date"
};

jobOutputFinalColumns = {
    "buyer_team__reference",
    "job_text_id",
    "job_id",
    "job_title",
    "job_created_by_name",
    "job_status",
    "job_public_url",
    "category",
    "subcategory",
    "job_created_date"
};

jobMasterColumns = {"auth_user", "jobs"};
jobMaster2Columns = {"job", "lister"};

freelancerColumns = {

    "dev_recno",
    "dev_short_name",
    "dev_country",
    "dev_city",
    "dev_is_affiliated",
    "dev_ac_agencies",
    "_is_error",
    "_error_code",
    "_error_message"
};

freelancerOutputColumns = {
    
    "freelancer_id",
    "freelancer_name",
    "country",
    "city",
    "is_affiliated_to_agency",
    "dev_ac_agencies",
    "_is_error",
    "_error_code",
    "_error_message"
};

freelancerOutputFinalColumns = {

    "freelancer_text_id",
    "freelancer_id",
    "freelancer_name",
    "country",
    "city",
    "is_affiliated_to_agency",
    "agency_name",
    "freelancer_profile_url",
    "_is_error",
    "_error_code",
    "_error_message"
};

freelancerMasterColumns = {"auth_user", "profile"};

billingMasterColumns = {"auth_user", "table"};

billingOutputFinalColumns = {

    "team_id",
    "contract_id",
    "billing_month",
    "amount_spent"
};

errorColumns = {
    "message",
    "reason"
};

[DataSource.Kind="Upwork", Publish="Upwork.Publish"]
shared Upwork.Contents = Value.ReplaceType(Upwork.NavImpl, Upwork.NavImplType);

Upwork.NavImplType = type function() as table
        meta [
            Documentation.Name = Extension.LoadString("Upwork.Contents.Name"),
            Documentation.LongDescription = Extension.LoadString("Upwork.Contents.LongDescription")
        ];

Upwork.NavImpl =  () as table =>
    let
        objects = #table(
            {"Name",       "Key",  "Data", "ItemKind", "ItemName", "IsLeaf"},{
            {"Teams",   "Teams",  Upwork.GetTeams() , "Table",    "Table",    true},
            {"Contracts",   "Contracts",  Upwork.GetContracts() , "Table",    "Table",    true},
            {"Freelancers",   "Freelancers",  Upwork.GetFreelancers() , "Table",    "Table",    true},
            {"Jobs",   "Jobs",  Upwork.GetJobs() , "Table",    "Table",    true},
            {"Billing",   "Billing",  Upwork.GetBilling() , "Table",    "Table",    true}
        }),
        NavTable = Upwork.ToNavigationTable(objects, {"Key"}, "Name", "Data", "ItemKind", "ItemName", "IsLeaf")
    in
        NavTable;


// 
// 
//
// Get Teams
// Tested for:
// 1 team - SUCCESS
// More than 1 teams - SUCCESS
//

[DataSource.Kind="Upwork"]
shared Upwork.GetTeams = Value.ReplaceType(Upwork.GetTeamsImpl, Upwork.GetTeamsImplType);

Upwork.GetTeamsImplType = type function() as table
        meta [
            Documentation.Name = Extension.LoadString("Upwork.GetTeams.Name"),
            Documentation.LongDescription = Extension.LoadString("Upwork.GetTeams.LongDescription")
        ];


Upwork.GetTeamsImpl = () =>
    let
        url = teamUrl,
        parameters = [],
        response =  Upwork.Request2(false, url, parameters),
        json = Json.Document(response),
        teamMaster = Table.Transpose(Record.ToTable(json)),
        teamMasterTable = Table.PromoteHeaders(teamMaster, [PromoteAllScalars=true]),
        table = Table.ExpandListColumn(teamMasterTable, "teams"),
        expanded = Table.ExpandRecordColumn(table, "teams", teamColumns, teamOutputColumns),

        teams = Table.SelectColumns(expanded, teamOutputFinalColumns),
       
        teamsTable = Table.RenameColumns(teams,{{"server_time", "refreshed_date"}}),

        transformedDate = Table.TransformColumns(teamsTable, 
                                                    {{"refreshed_date", each Upwork.FromTimestampToDate(_)}}),

        transformedTable = Table.TransformColumnTypes(transformedDate,
                    {{"team_id", Int64.Type}, 
                    {"company_id", Int64.Type},
                    {"refreshed_date", type datetime}})
    in
        transformedTable;


//
// Get Contracts per Page
// url -> engagement url
// parameters -> parameters to pass to API, mostly we will pass pagination param
//
Upwork.GetContractsPerPage = (url, parameters) =>
    let
        response =  Json.Document(Upwork.Request2(false, url, parameters))
    in
        response;

//
// Get Contracts using pagination
//
Upwork.GetContractsPaged = (url) =>
    
    let
        contractsJsonPaginated = List.Generate( () => 
                        [pageResult = null, total_items = 0, nextOffset = 0, counter = 1],
                         each Number.From([total_items]) <> 0 or [counter] <= 1,
                        each [pageResult = try Upwork.GetContractsPerPage(url, 
                                                       [page=Text.From([nextOffset]) & ";" & Text.From(recordsPerPage)]) 
                                           otherwise null, 
                                total_items = try pageResult[engagements][lister][total_items] otherwise 0,
                                nextOffset = [nextOffset] + recordsPerPage,
                                counter = [counter] + 1],
                        each [pageResult]),
        
        contractsJsonPaginated2 = List.Skip(contractsJsonPaginated, 1),
        table = Table.FromList(contractsJsonPaginated2, Splitter.SplitByNothing(), null, null, ExtraValues.Error),

        //CODE FOR HANDLING NO DATA
        tableWithCheck = if Table.IsEmpty(table) then #table(type table[Column1 = [server_time=any,
                                                                                auth_user=any,
                                                                                engagements=any]], {}) else table,
 

        expanded = Table.ExpandRecordColumn(tableWithCheck, "Column1", contractMasterColumns, contractMasterColumns),
        expanded2 = Table.ExpandRecordColumn(expanded, "engagements", contractEnagementColumns, contractEnagementColumns), 

        //API RETURNS AN ARRAY IF MORE THAN ONE ENTRY, NO ARRAY IF ONE ENTRY
        convertToList = Table.TransformColumns(expanded2, { "engagement", each if Value.Is( _, type record ) then { _ } else _ } ),
        listExpanded = Table.ExpandListColumn(convertToList, "engagement"),
        allEngagements = Table.ExpandRecordColumn(listExpanded, "engagement", contractColumns, contractOutputColumns),
    
        allEngagementsSelectedColumns = Table.SelectColumns(allEngagements, contractOutputColumns)

    in
        allEngagementsSelectedColumns;

//
// Get All Contracts through pagination
// Tested for
// 0 contracts - SUCCESS
// 1 contract - 
// More than 1 contracts - SUCCESS 
//
[DataSource.Kind="Upwork"]
shared Upwork.GetContracts = Value.ReplaceType(Upwork.GetContractsImpl, Upwork.GetContractsImplType);

Upwork.GetContractsImplType = type function() as table
        meta [
            Documentation.Name = Extension.LoadString("Upwork.GetContracts.Name"),
            Documentation.LongDescription = Extension.LoadString("Upwork.GetContracts.LongDescription")
        ];

Upwork.GetContractsImpl = () =>
    let
        url = contractUrl,

        //Get Contracts base data
        allEngagementsSelectedColumns = Upwork.GetContractsPaged(url),
        
        //FEEDBACK RECORD
        feedbackRecord = Table.TransformColumns(allEngagementsSelectedColumns, {{"feedback", each if _ = "" then [] else _}}),
        expandedFeedbackRecord = Table.ExpandRecordColumn(feedbackRecord, "feedback", feedbackColumns, feedbackColumns),
        expandedSubFeedbackRecord = Table.ExpandRecordColumn(expandedFeedbackRecord, "feedback_for_buyer", {"score"}, {"feedback_to_client_score"}),
        expandedSubFeedbackRecord2 = Table.ExpandRecordColumn(expandedSubFeedbackRecord, "feedback_for_provider", {"score"}, {"feedback_to_freelancer_score"}),

        contractsTable = Table.SelectColumns(expandedSubFeedbackRecord2, contractOutputFinalColumns),
      
        withProfileUrl = Table.AddColumn(contractsTable, "contract_url", 
                                        each contractProfileUrl & [buyer_team_id] & "/contracts/" & [contract_id]),

        transformedDate = Table.TransformColumns(withProfileUrl, 
                                                       {{"accept_date", each Upwork.FromTimestampToDate(_)},
                                                       {"start_date", each Upwork.FromTimestampToDate(_)},
                                                       {"end_date", each Upwork.FromTimestampToDate(_)}                                                                           
                                                       }),

        transformedTable = Table.TransformColumnTypes(transformedDate,
                {
                {"buyer_team_id", Int64.Type}, 
                {"hourly_charge_rate", Currency.Type}, 
                {"weekly_hours_limit", type number}, 
                {"freelancer_id", Int64.Type}, 
                {"offer_id", Int64.Type},
                {"contract_id", Int64.Type},
                {"accept_date", type datetime},
                {"start_date", type datetime},
                {"end_date", type datetime}})
    in
        transformedTable;



//
// Get Contracts per Page
// url -> engagement url
// parameters -> parameters to pass to API, mostly we will pass pagination param
// Note: In some cases you can view a team but may not have access to see jobs in that team,
// so passing true in 4th param of Upwork.Request2
//
Upwork.GetJobsPerPage = (url, parameters) =>
    let
        response =  Json.Document(Upwork.Request2(false, url, parameters, true))
    in
        response;


//
// Get Jobs per team
// url -> job url
// parameters -> team_reference parameter
Upwork.GetJobsPerTeam = (url, parameters) =>
    let
        jobsJsonPaginated = List.Generate( () => 
                        [pageResult = null, total_items = 0, nextOffset = 0, counter = 1],
                        each Number.From([total_items]) <> 0 or [counter] <= 1,
                        each [pageResult = try Upwork.GetJobsPerPage(url, 
                                                             parameters & [page=Text.From([nextOffset]) & ";" & Text.From(recordsPerPage)]) 
                                            otherwise null, 
                                total_items = try pageResult[jobs][lister][total_items] otherwise 0,
                                nextOffset = [nextOffset] + recordsPerPage,
                                counter = [counter] + 1],
                        each [pageResult]),
        
        jobsJsonPaginated2 = List.Skip(jobsJsonPaginated, 1)
    in 
        jobsJsonPaginated2;

//
// Get Jobs
// Jobs are per team, get teams first and then iterate over each team to get jobs
// Tested for:
// 0 job - SUCCESS
// 1 job - SUCCESS
// More than 1 jobs - SUCCESS
//
[DataSource.Kind="Upwork"]
shared Upwork.GetJobs = Value.ReplaceType(Upwork.GetJobsImpl, Upwork.GetJobsImplType);

Upwork.GetJobsImplType = type function() as table
        meta [
            Documentation.Name = Extension.LoadString("Upwork.GetJobs.Name"),
            Documentation.LongDescription = Extension.LoadString("Upwork.GetJobs.LongDescription")
        ];


Upwork.GetJobsImpl = () =>
    let
        url = jobUrl,
        teams = Upwork.GetTeams(),
        response = Table.AddColumn(teams, "Jobs", each 
                                                    try Upwork.GetJobsPerTeam(url, 
                                                                        [buyer_team__reference=Text.From([team_id]), 
                                                                        include_sub_teams=Text.From(1)])
                                                    otherwise null),

        table = Table.ExpandListColumn(response, "Jobs"),
       
        //CODE FOR HANDLING NO DATA
        tableWithCheck = if Table.IsEmpty(table) then #table(type table[Jobs = {[server_time=any,
                                                                                auth_user=any,
                                                                                jobs=any]}], {}) else table,
 
        expanded1 = Table.ExpandRecordColumn(tableWithCheck, "Jobs", jobMasterColumns, jobMasterColumns),
        expanded2 = Table.ExpandRecordColumn(expanded1, "jobs", jobMaster2Columns, jobMaster2Columns), 

        //API RETURNS AN ARRAY IF MORE THAN ONE ENTRY, NO ARRAY IF ONE ENTRY
        convertToList = Table.TransformColumns(expanded2, { "job", each if Value.Is( _, type record ) then { _ } else _ } ),
        listExpanded = Table.ExpandListColumn(convertToList, "job"),
        jobs = Table.ExpandRecordColumn(listExpanded, "job", jobColumns, jobOutputColumns),
    
        jobsOutputTable = Table.SelectColumns(jobs, jobOutputFinalColumns),
        
        //rename column since when fetching for say buyer_team__reference A, sometimes in output
        //I see sub team in buyer_team__reference column
        jobsTable = Table.RenameColumns(jobsOutputTable, {{"buyer_team__reference", "team_id"}}),

        //remove duplicates since sometimes subteams information is included when fetching teams information
        jobsUniqueTable = Table.Distinct(jobsTable),

        transformedDate = Table.TransformColumns(jobsUniqueTable, 
                                                       {{"job_created_date", each Upwork.FromTimestampToDate(_)}}),
                                                      
        //remove null jobs
        removeBlankRows = Table.SelectRows(transformedDate, each [job_text_id] <> null),

        transformedTable = Table.TransformColumnTypes(removeBlankRows,
                {{"job_created_date", type datetime},
                {"team_id", Int64.Type}})

    in
        transformedTable;



//
// Get Freelancer's Profile
// Note: sometimes this API fails with 403 error code if profile is disabled
// freelanceRef -> reference freelancer
//
Upwork.GetFreelancerProfile = (freelanceRef) =>
    let 
        url2 = freelancePrefixUrl & freelanceRef & freelanceSuffixUrl,
        parameters = [],
        response = Json.Document(Upwork.Request2(false, url2, parameters, true)),

        errorCode = try response[error][status] otherwise 200,
        output = if errorCode = 403 
                    then [profile=[_is_error=Extension.LoadString("YesString"), 
                                   _error_code=errorCode, 
                                   _error_message=response[error][message]]] else response
    in
        output;

//
// Get Freelancers
// No bulk freelancers API available, hence get contracts first and then query to get freelancer info
// Tested for:
// 0 contracts - SUCCESS
// 1 freelancer - SUCCESS
// more than 1 freelancers - SUCCESS
//
[DataSource.Kind="Upwork"]
shared Upwork.GetFreelancers = Value.ReplaceType(Upwork.GetFreelancersImpl, Upwork.GetFreelancersImplType);

Upwork.GetFreelancersImplType = type function() as table
        meta [
            Documentation.Name = Extension.LoadString("Upwork.GetFreelancers.Name"),
            Documentation.LongDescription = Extension.LoadString("Upwork.GetFreelancers.LongDescription")
        ];

Upwork.GetFreelancersImpl = () =>
    let
        contracts = Upwork.GetContractsPaged(contractUrl),

        freelancerSelectedColumns = Table.SelectColumns(contracts, {"freelancer_text_id"}),
        uniqueFreelancers = Table.Distinct(freelancerSelectedColumns),
       
                       
        //ADD PROFILE URL
        freelancerTable = Table.AddColumn(uniqueFreelancers, "freelancer_profile_url", each freelanceProfileUrl & [freelancer_text_id]),

        withFreelancerCall = Table.AddColumn(freelancerTable, "freelancer", 
                                             each try 
                                                    Upwork.GetFreelancerProfile([freelancer_text_id])
                                                  otherwise 
                                                    null),
        expandedFreelancerMasterRecord = Table.ExpandRecordColumn(withFreelancerCall, "freelancer", freelancerMasterColumns, freelancerMasterColumns),
        expandedFreelancerRecord = Table.ExpandRecordColumn(expandedFreelancerMasterRecord, "profile", freelancerColumns, freelancerOutputColumns),

        //EXTRACT AGENCY RECORD
        agencyRecord = Table.TransformColumns(expandedFreelancerRecord, {"dev_ac_agencies", 
                                                        each if _ = "" then [] 
                                                             else _ }),

        expanded = Table.ExpandRecordColumn(agencyRecord, "dev_ac_agencies", {"dev_ac_agency"}, {"dev_ac_agency"}), 

         //API RETURNS AN ARRAY IF MORE THAN ONE ENTRY, NO ARRAY IF ONE ENTRY
        agencyNameList = Table.TransformColumns(expanded, { "dev_ac_agency", each if Value.Is( _, type record ) then { _ } else _ } ),

        firstAgencyName = Table.TransformColumns(agencyNameList, { "dev_ac_agency", 
                                                                each if Value.Is(_, type list) then List.First(_) 
                                                                else _}),
        withAgencyName = Table.ExpandRecordColumn(firstAgencyName, "dev_ac_agency", {"ag_name"}, {"agency_name"}),

        freelancerSelectedTable = Table.SelectColumns(withAgencyName, freelancerOutputFinalColumns),

        //UPDATE DATA TYPES
        transformedTable = Table.TransformColumnTypes(freelancerSelectedTable,
                        {{"freelancer_id", Int64.Type}})
    in 
       transformedTable;

//
// Converts unix timestamp to date
// timestamp -> unix timestamp
//
Upwork.FromTimestampToDate = (timestamp as any) as any =>
    let
        extractedTimestamp = if timestamp <> null and Text.Length(timestamp) > 10 then Text.Range(timestamp, 0, 10) else timestamp,
        timestampToNumber = try Number.From(extractedTimestamp) otherwise null,
        date = if timestampToNumber <> null then #datetime(1970, 1, 1, 0, 0, 0) + #duration(0, 0, 0, timestampToNumber) else null
    in 
       date; 
//
// Get first day of month starting from startdate till enddate
// startdate -> start date to generate dates
// enddate -> end date
//
Upwork.GetMonthFirstDates = (startdate as date, enddate as date) =>
    let
         Source = List.Generate(
                () => [Date = startdate],
                each [Date] <= enddate,
                each [Date = Date.AddMonths([Date],1)],
                each [Date])

    in
        Source;

//
// Get Billing details
// teamRef -> reference team
// contractRef -> reference engagement
//
Upwork.GetBillingByTeamByContract = (teamRef, contractRef) =>
    let
        url = billingPrefixUrl & teamRef & billingSuffixUrl,
        parameters = [tq=billingQuery & contractRef],
        response = Json.Document(Upwork.Request2(false, url, parameters))
    in
        response;


// 
// Get Billing details
// teamRef -> reference team
// querydate -> date filter for query
//
Upwork.GetBillingByTeam = (teamRef, querydate) =>
    let
        url = billingPrefixUrl & teamRef & billingSuffixUrl,
        billingQuerySDate = Text.Replace(billingQuery2, "$sdate$", Date.ToText(querydate, "yyyy-MM-dd")),
        billingQueryEDate = Text.Replace(billingQuerySDate, 
                                        "$edate$", 
                                        Date.ToText(Date.AddDays(Date.AddMonths(querydate,1),-1), "yyyy-MM-dd")),
        parameters = [tq=billingQueryEDate],
        response = Json.Document(Upwork.Request2(false, url, parameters))
    in
        response;

// 
// Get Billing details
// Tested for
// 0 billing records per team - SUCCESS
// 1 billing record per team - SUCCESS
// More than 1 billing records per team - SUCCESS
//
[DataSource.Kind="Upwork"]
shared Upwork.GetBilling = Value.ReplaceType(Upwork.GetBillingImpl, Upwork.GetBillingImplType);

Upwork.GetBillingImplType = type function() as table
        meta [
            Documentation.Name = Extension.LoadString("Upwork.GetBilling.Name"),
            Documentation.LongDescription = Extension.LoadString("Upwork.GetBilling.LongDescription")
        ];

Upwork.GetBillingImpl = () =>
    let
        teams = Upwork.GetTeams(),
        teamsWithMonths = Table.AddColumn(teams, "billing_month", 
                                          each Upwork.GetMonthFirstDates(#date(2018,1,1), 
                                                             DateTime.Date(DateTime.LocalNow())), 
                                          type date),
       
        queryTable = Table.ExpandListColumn(teamsWithMonths, "billing_month"),
      
        //Get billing per team and per month
        response = Table.AddColumn(queryTable, "Billing", each 
                                                    try Upwork.GetBillingByTeam(Text.From([team_id]), [billing_month])
                                                    otherwise null),
        
        expandedMasterBilling = Table.ExpandRecordColumn(response, "Billing", billingMasterColumns, billingMasterColumns),
        expandedRows = Table.ExpandRecordColumn(expandedMasterBilling, "table", {"rows"}, {"rows"}),
        expandedRowsList = Table.ExpandListColumn(expandedRows, "rows"),
        expandedColumns = Table.ExpandRecordColumn(expandedRowsList, "rows", {"c"}, {"c"}),

        //first column is contract_id
        col1 = Table.AddColumn(expandedColumns, "reference", each if Value.Is([c], type list) then List.First([c]) 
                                                             else [c]),
       
        //last column is amount_spent
        col2 = Table.AddColumn(col1, "amount", each if Value.Is([c], type list) then List.Last([c]) else [c]),
        expandedReference = Table.ExpandRecordColumn(col2, "reference", {"v"}, {"contract_id"}),
        expandedAmount = Table.ExpandRecordColumn(expandedReference, "amount", {"v"}, {"amount_spent"}),
        billingTable = Table.SelectColumns(expandedAmount, billingOutputFinalColumns),

        filteredTable = Table.SelectRows(billingTable, each [contract_id] <> null),

        transformedTable = Table.TransformColumnTypes(filteredTable,
                {{"amount_spent", Currency.Type},
                {"billing_month", type date},
                {"team_id", Int64.Type},
                {"contract_id", Int64.Type}})

    in
        transformedTable;


/* Helper functions for making OAuth 1.0 requests after getting token */
Upwork.Request2 = (isPost, url, parameters, optional isManualStatusHandling) =>
    let
        credential = Extension.CurrentCredential(),
        auth = [oauth_consumer_key = clientId, oauth_token = credential[Properties][oauth_token]],
        response = Upwork.Request(isPost, 
                                 url, 
                                 auth, 
                                 parameters, 
                                 clientSecret, 
                                 credential[Properties][oauth_token_secret], 
                                 "application/json", 
                                 isManualStatusHandling)
    in
        response;
        

/* Helper functions for making OAuth 1.0 requests taken from Twitter search code by Curt, and
and modified for this connector
https://github.com/CurtHagenlocher/Twitter/blob/master/Twitter.pq
*/
Upwork.Request = 
            (isPost, // post or get 
            relativeUrl,  //relative url to base
            authProps, //authentication properties
            otherProps, //other api properties
            secret1, //secret
            secret2, //token
            optional accept, //accept
            optional isManualStatusHandling //for manually handling errors
            ) =>
    let
        url = baseUrl & relativeUrl,
        method = if isPost then "POST" else "GET",
        combined = authProps & otherProps & [
            oauth_signature_method="HMAC-SHA1",
            oauth_nonce = Text.NewGuid(),
            oauth_timestamp = Number.ToText(Number.Round(Duration.TotalSeconds(DateTimeZone.UtcNow() - #datetimezone(1970, 1, 1, 0, 0, 0, 0, 0)))),
            oauth_version = "1.0"
        ],
        fieldNames = List.Sort(Record.FieldNames(combined)),
        pairs = List.Transform(fieldNames, (f) => f & "=" & Uri.EscapeDataString(Record.Field(combined, f))),
        combinedpairs = Text.Combine(pairs, "&"),
        baseString = method & "&" & Uri.EscapeDataString(url) & "&" & Uri.EscapeDataString(combinedpairs),
        compositeKey = Uri.EscapeDataString(secret1) & "&" & Uri.EscapeDataString(secret2),
        signature = Binary.ToText(Crypto.CreateHmac(CryptoAlgorithm.SHA1, Text.ToBinary(compositeKey), Text.ToBinary(baseString)), BinaryEncoding.Base64),
        withSignature = combined & [oauth_signature = signature],
        allNames = Record.FieldNames(withSignature),
        otherNames = Record.FieldNames(otherProps),
        included = List.Select(allNames, each not List.Contains(otherNames, _)),
        includedPairs = List.Transform(included, (f) => f & "=""" & Uri.EscapeDataString(Record.Field(withSignature, f)) & """"),
        auth = [Authorization = "OAuth " & Text.Combine(includedPairs, ", ")],
        headers = if accept = null then auth else auth & [Accept=accept],
        queryString = Uri.BuildQueryString(otherProps),
        options = if isPost then [Headers = [#"Content-type" = "application/x-www-form-urlencoded"] & headers, Content = Text.ToBinary(queryString)] else [Headers = headers],
        actualUrl = if isPost or Text.Length(queryString) = 0 then relativeUrl else relativeUrl & "?" & queryString,
        relativePath = [RelativePath = actualUrl],
        manualStatusHandling = if isManualStatusHandling = true then [ManualStatusHandling={403}] else [],
        result = Web.Contents(baseUrl, manualStatusHandling & relativePath & options & [ManualCredentials=true])
    in
        result;

Upwork.FromParts = (parts) =>
    let
        port = if (parts[Scheme] = "https" and parts[Port] = 443) or (parts[Scheme] = "http" and parts[Port] = 80) then "" else ":" & Text.From(parts[Port]),
        div1 = if Record.FieldCount(parts[Query]) > 0 then "?" else "",
        div2 = if Text.Length(parts[Fragment]) > 0 then "#" else "",
        uri = Text.Combine({parts[Scheme], "://", parts[Host], port, parts[Path], div1, Uri.BuildQueryString(parts[Query]), div2, parts[Fragment]})
    in
        uri;

Upwork.Get = (url, authProps, secret1, secret2, optional accept) =>
    let
        parts = Uri.Parts(url),
        otherProps = parts[Query],
        url2 = Upwork.FromParts(parts & [Query=[]])
    in
        Upwork.Request(false, url2, authProps, otherProps, secret1, secret2, accept);

Upwork.GetRequestToken = () =>
    let
        auth = [oauth_callback = callbackUrl, oauth_consumer_key = clientId],
        Response = Upwork.Request(true, requestTokenUrl, auth, [], clientSecret, ""),
        Parts = Uri.Parts("http://localhost?" & Text.FromBinary(Response))[Query]
    in
        Parts;

/* Authentication functions provided by SDK */
Upwork.StartLogin = (resourceUrl, state, display) =>
    let
        Token = Upwork.GetRequestToken(),
        AuthorizeUrl = baseUrl & authenticateUrl & "?oauth_token=" & Uri.EscapeDataString(Token[oauth_token])
    in
        [
            LoginUri = AuthorizeUrl,
            CallbackUri = callbackUrl,
            WindowHeight = windowHeight,
            WindowWidth = windowWidth,
            Context = Token
        ];

Upwork.FinishLogin = (context, callbackUri, state) =>
    let
        Token = context,
        QueryParts = Uri.Parts(callbackUri)[Query],
        auth = [oauth_token = Token[oauth_token], oauth_consumer_key = clientId],
        verifier = [oauth_verifier = QueryParts[oauth_verifier]],
        Response = Upwork.Request(true, accessTokenUrl, auth, verifier, clientSecret, Token[oauth_token_secret]),
        Parts = Uri.Parts("http://localhost?" & Text.FromBinary(Response))[Query]
    in
        Parts & [access_token="OnlyForOAuth2.0"];

//Data Source Kind description
Upwork = [
    // TestConnection is required to enable the connector through the Gateway
    TestConnection = (dataSourcePath) => { "Upwork.Contents" },
    Authentication = [
        OAuth=
            [StartLogin=Upwork.StartLogin, 
            FinishLogin=Upwork.FinishLogin]
    ],
    Label = Extension.LoadString("DataSourceLabel")
];


// Data Source UI publishing description
Upwork.Publish = [
    Beta = true,
    Category = Extension.LoadString("ConnectorCategory"),
    ButtonText = { Extension.LoadString("ButtonTitle"), Extension.LoadString("ButtonHelp") },
    LearnMoreUrl = "https://powerbi.microsoft.com/",
    SourceImage = Upwork.Icons,
    SourceTypeImage = Upwork.Icons
];

Upwork.Icons = [
    Icon16 = { Extension.Contents("Upwork16.png"), Extension.Contents("Upwork20.png"), Extension.Contents("Upwork24.png"), Extension.Contents("Upwork32.png") },
    Icon32 = { Extension.Contents("Upwork32.png"), Extension.Contents("Upwork40.png"), Extension.Contents("Upwork48.png"), Extension.Contents("Upwork64.png") }
];

// Navigation Table Helper
Upwork.ToNavigationTable =
(
    table as table,
    keyColumns as list,
    nameColumn as text,
    dataColumn as text,
    itemKindColumn as text,
    itemNameColumn as text,
    isLeafColumn as text
) as table =>
    let
        tableType = Value.Type(table),
        newTableType = Type.AddTableKey(tableType, keyColumns, true) meta 
        [
            NavigationTable.NameColumn = nameColumn, 
            NavigationTable.DataColumn = dataColumn,
            NavigationTable.ItemKindColumn = itemKindColumn, 
            Preview.DelayColumn = dataColumn, 
            NavigationTable.IsLeafColumn = isLeafColumn
        ],
        navigationTable = Value.ReplaceType(table, newTableType)
    in
        navigationTable;