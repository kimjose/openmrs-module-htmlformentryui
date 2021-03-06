<%
    ui.decorateWith("appui", "standardEmrPage", [patient: currentPatient])
    ui.includeJavascript("uicommons", "moment.min.js")
    ui.includeJavascript("uicommons", "emr.js", 50)
    ui.includeJavascript("htmlformentryui", "flowsheet.js")
    ui.includeJavascript("htmlformentryui", "jstat.min.js")
    ui.includeJavascript("htmlformentryui", "htmlForm.js")
    ui.includeCss("htmlformentryui", "htmlform/referenceappmini.css")
    ui.includeCss("kenyaemr", "referenceapplication.css")


    def addNewRow = (addRow != null && addRow == true) ? true : false;
%>

<script type="text/javascript">

    var patientIdStr = '${ patient.patient.patientId }';
    var patientUuidStr = '${ patient.patient.uuid }';

    flowsheet.setPatientId(${ patient.patient.patientId });
    flowsheet.setHeaderForm('${ headerForm }');
    flowsheet.setHeaderEncounterId(${ headerEncounter == null ? null : headerEncounter.encounterId });
    flowsheet.setHtmlFormJs(htmlForm); // This is the htmlform object added to the page by htmlformentryui htmlform.js
    flowsheet.setDefaultLocationId(${ defaultLocationId });
    flowsheet.setRequireEncounter(${ requireEncounter });

    <% if (dashboardUrl != null && !dashboardUrl.equals("")) { %>
    <% if (dashboardUrl.equals("legacyui")) { %>
    flowsheet.setPatientDashboardUrl('/' + OPENMRS_CONTEXT_PATH + '/patientDashboard.form?patientId=' + patientIdStr);
    <% } else { %>
    var dashboardUrl = '${dashboardUrl}'.replace("\\{\\{patientId\\}\\}", patientIdStr).replace("\\{\\{patientUuid\\}\\}", patientUuidStr);
    flowsheet.setPatientDashboardUrl('/' + OPENMRS_CONTEXT_PATH + '/' + dashboardUrl);
    <% } %>
    <% } else { %>
    flowsheet.setPatientDashboardUrl('/' + OPENMRS_CONTEXT_PATH + '/kenyaemr/clinicianFacing/patientProfile.page?patientId=' + patientIdStr)
    <% } %>

    var flowsheetIndex = 0;
    <% for (String formName : flowsheetEncounters.keySet()) { %>
    flowsheet.addFlowsheet(flowsheetIndex++, '${formName}', ${flowsheetEncounters.get(formName)});
    <% } %>

    jq(document).ready(function () {

        <% if (headerEncounter == null && requireEncounter) { %>
        flowsheet.enterHeader();
        <% } else { %>
        flowsheet.viewHeader();
        flowsheet.loadVisitTable();
        <% } %>
        flowsheet.focusFirstObs();

        <% if (viewOnly) { %>
        flowsheet.enableViewOnly();
        <% } %>

        // warn user about changes before leaving page
        jq(window).bind('beforeunload', function () {
            if (flowsheet.isDirty()) {
                return "If you leave this page you will lose unsaved changes";
            }
        });

    });
</script>

<style>
body {
    width: 99%;
    max-width: none;
    font-size: 9pt;
}

@media (max-width: 1024px) {
    body {
        font-size: 9px;
    }
}

a {
    cursor: pointer;
}

td {
    vertical-align: middle;
}

#form-actions {
    float: right;
}

.form-action-link {
    padding-left: 10px;
    padding-right: 10px;
}

#htmlform {
    width: 100%;
}

form input, form select, form textarea, form ul.select, form label, .form input, .form select, .form textarea, .form ul.select .form label {
    display: inline;
    min-width: inherit;
}

form input[type="checkbox"], form input[type="radio"], .form input[type="checkbox"], .form input[type="radio"] {
    float: inherit;
}

.left-cell {
    padding-right: 5px;
    border-right: 1px solid #DDD;
}

.right-cell {
    padding-left: 5px;
}

.hasDatepicker {
    width: 100px;
}

table .visit-table {
    width: 100%;
}

table .visit-table-header td {
    border: 1px dotted #DDD;
    vertical-align: middle;
    text-align: center;
    background-color: rgb(255, 253, 247);
}

table .visit-table-body td {
    text-align: center;
}

#error-message-section {
    display: none;
    padding: 10px;
    font-weight: bold;
    color: red;
    border: 1px dotted red;
    width: 75%;
}

#header-section {
    width: 100%;
}

#visit-flowsheet-section {
    width: 100%;
    padding-top: 5px;
}

.visit-table-header {
    border: 2px solid #DDD;
}

#alert-section {
    padding: 10px;
    border-bottom: 1px solid black;
    margin-bottom: 10px;
}

#alert-table {
    color: red;
}

.nowrap {
    white-space: nowrap;
}

.value {
    font-weight: bold;
}

.units {
    padding-left: 10px;
}

.error {
    padding: 5px;
    font-weight: bold;
    color: red;
}

.td-error {
    padding: 5px;
    font-weight: bold;
    color: red;
    border: 2px dotted red;
}

.visit-edit-table th {
    text-align: left;
    white-space: nowrap;
    padding: 10px;
}

.visit-edit-table td {
    text-align: left;
    width: 100%;
    padding: 10px;
}

.toast-container {
    display: none;
}

.visit-section {
    margin-top: 10px;
}

.add-another-flowsheet-section {
    padding: 0px;
}

.data-entry-table {
    border: none;
    width: 100%;
    overflow-x: auto;
    display: block;
}

/* This is an attempt at rotating the table headers to appear vertical, but this isn't used yet */
.rotate-attempt {
    -moz-transform: rotate(-90.0deg); /* FF3.5+ */
    -o-transform: rotate(-90.0deg); /* Opera 10.5 */
    -webkit-transform: rotate(-90.0deg); /* Saf3.1+, Chrome */
    filter: progid:DXImageTransform.Microsoft.BasicImage(rotation=0.083); /* IE6,IE7 */
    -ms-filter: "progid:DXImageTransform.Microsoft.BasicImage(rotation=0.083)"; /* IE8 */
}

form input[disabled], .form input[disabled] {
    background-color: rgb(235, 235, 228);
}
</style>

<style type="text/css" media="print">
@page {
    size: landscape;
    margin: .2in;
}

.hide-when-printing {
    display: none;
}

body {
    font-size: .5em;
}



</style>

<div id="flowsheet-app" style="margin-left: 6px;">

    <% if (!alerts.empty) { %>
    <div id="alert-section" class="hide-when-printing">
        <table id="alert-table">
            <% alerts.each { alert -> %>
            <tr>
                <td class="alert">${alert}</td>
            </tr>
            <% } %>
        </table>
    </div>
    <% } %>

    <div id="form-actions" class="hide-when-printing">
        <a class="form-action-link" id="back-link" onclick="flowsheet.backToPatientDashboard();">
            <i class="fa fa-chevron-left" style="font-size:16px;color:steelblue"></i>
            Back to Dashboard
        </a>
        <% if (headerForm != 'blank_header') { %>
        <a class="form-action-link" id="edit-header-link" onclick="flowsheet.enterHeader();">
            <i class="fa fa-pencil" style="font-size:16px;color:steelblue"></i>
            Edit Header
        </a>
        <% } %>
        <a class="form-action-link" id="print-form-link" onclick="flowsheet.printForm();">
            <i class="fa fa-print" style="font-size:16px;color:steelblue"></i>
            ${ui.message("uicommons.print")}
        </a>
        <a class="form-action-link" id="cancel-button" onclick="flowsheet.cancelEdit();">
            <i class="fa fa-close" style="font-size:16px;color:red"></i>
            ${ui.message("uicommons.cancel")}
        </a>
        <a class="form-action-link" id="delete-button" onclick="flowsheet.deleteCurrentEncounter();">
            <i class="fa fa-trash-o" style="font-size:16px;color:red"></i>
            ${ui.message("uicommons.delete")}
        </a>
    </div>

    <div id="error-message-section"></div>

    <% if (headerForm != 'blank_header') { %>
    <div id="header-section"></div>
    <% } %>

    <% int i = 0;
    for (String formName : flowsheetEncounters.keySet()) { %>

    <div class="visit-section" style="margin-left: 7px">

        <% if (!viewOnly && formName != 'blank' && addNewRow == true) { %>
        <fieldset id="fieldset_index_${i}">
            <legend>${flowsheetForms.get(formName).name}</legend>

            <div class="add-another-flowsheet-section flowsheet-section">
                <a class="form-action-link" onclick="flowsheet.enterVisit('${formName}');">
                    <i class="fa fa-file-text" style="color:steelblue"></i>
                    Enter New ${flowsheetForms.get(formName).name}
                </a>
            </div>



            <% } %>

            <div id="flowsheet-section-${i}" class="flowsheet-section"></div>

            <div id="flowsheet-edit-section-${i}" class="flowsheet-edit-section"></div>

            <% i++; %>
        </fieldset>
    </div>
    <% } %>

    <br/>
</div>
