import ballerina/log;
import wso2/choreo.sendemail;
import ballerinax/trigger.github;
import ballerina/http;

configurable string gitWebhookSecret = ?;
configurable string toEmail = ?;
github:ListenerConfig config = {
    "secret": gitWebhookSecret
};

listener http:Listener httpListener = new (8090);
listener github:Listener webhookListener = new (config, httpListener);

service github:IssuesService on webhookListener {

    remote function onOpened(github:IssuesEvent payload) returns error? {
        error? handleIssueEventResult = handleIssueEvent(payload, "Opened: ", "Issue Opened: ");
        if handleIssueEventResult is error {
            log:printInfo("Error onOpened: " + handleIssueEventResult.message());
        }
    }

    remote function onClosed(github:IssuesEvent payload) returns error? {
        error? handleIssueEventResult = handleIssueEvent(payload, "Closed: ", "Issue Closed: ");
        if handleIssueEventResult is error {
            log:printInfo("Error onClosed: " + handleIssueEventResult.message());
        }
    }

    remote function onReopened(github:IssuesEvent payload) returns error? {
        error? handleIssueEventResult = handleIssueEvent(payload, "Reopened: ", "Issue Reopened: ");
        if handleIssueEventResult is error {
            log:printInfo("Error onReopened: " + handleIssueEventResult.message());
        }
    }

    remote function onAssigned(github:IssuesEvent payload) returns error? {
        error? handleIssueEventResult = handleIssueEvent(payload, "Assigned: ", "Issue Assigned: ");
        if handleIssueEventResult is error {
            log:printInfo("Error onAssigned: " + handleIssueEventResult.message());
        }
    }

    remote function onUnassigned(github:IssuesEvent payload) returns error? {
        error? handleIssueEventResult = handleIssueEvent(payload, "Unassigned: ", "Issue Unassigned: ");
        if handleIssueEventResult is error {
            log:printInfo("Error onUnassigned: " + handleIssueEventResult.message());
        }
    }

    remote function onLabeled(github:IssuesEvent payload) returns error? {
        error? handleIssueEventResult = handleIssueEvent(payload, "Labeled: ", "Issue Labeled: ");
        if handleIssueEventResult is error {
            log:printInfo("Error onLabeled: " + handleIssueEventResult.message());
        }
    }

    remote function onUnlabeled(github:IssuesEvent payload) returns error? {
        error? handleIssueEventResult = handleIssueEvent(payload, "Unlabeled: ", "Issue Unlabeled: ");
        if handleIssueEventResult is error {
            log:printInfo("Error onUnlabeled: " + handleIssueEventResult.message());
        }
    }
}

function handleIssueEvent(github:IssuesEvent payload, string emailSubject, string eventType) returns error? {
    github:Label? label = payload.label;
    if label is github:Label {
        sendemail:Client sendemailEp = check new ();
        do {
	        string sendEmailResponse = check sendemailEp->sendEmail(toEmail, subject = emailSubject + payload.issue.title, body = "An issue has been " + eventType + ". Please check " + payload.issue.html_url);
            log:printInfo("Email sent " + sendEmailResponse);
        } on fail var e {
        	log:printInfo("Error Occurred " + e.message());
        }
        log:printInfo("Done! ");
    }
}
