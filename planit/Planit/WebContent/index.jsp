<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
    <head>
        <meta charset="utf-8">
        <title>Planit | Dashboard</title>
        <link rel="stylesheet" href="style.css">
        <link href='https://fonts.googleapis.com/css?family=Lato:400,700,300' rel='stylesheet' type='text/css'>
        <script src="jquery-2.1.4.min.js"></script>
        <script type="text/javascript">
          // Your Client ID can be retrieved from your project in the Google
          // Developer Console, https://console.developers.google.com
          var CLIENT_ID = '538542431930-l6i37emfe92fmo4ol1n0ll6db4lceu88.apps.googleusercontent.com';

          var SCOPES = ["https://www.googleapis.com/auth/calendar.readonly"];

          /**
           * Check if current user has authorized this application.
           */
          function checkAuth() {
            gapi.auth.authorize(
              {
                'client_id': CLIENT_ID,
                'scope': SCOPES.join(' '),
                'immediate': true
              }, handleAuthResult);
          }
		
          /**
           * Handle response from authorization server.
           *
           * @param {Object} authResult Authorization result.
           */
          function handleAuthResult(authResult) {
            var authorizeDiv = document.getElementById('authorize-div');
            if (authResult && !authResult.error) {
              // Hide auth UI, then load client library.
              authorizeDiv.style.display = 'none';
              loadCalendarApi();
            } else {
              // Show auth UI, allowing the user to initiate authorization by
              // clicking authorize button.
              authorizeDiv.style.display = 'inline';
            }
          }

          /**
           * Initiate auth flow in response to user clicking authorize button.
           *
           * @param {Event} event Button click event.
           */
          function handleAuthClick(event) {
            gapi.auth.authorize(
              {client_id: CLIENT_ID, scope: SCOPES, immediate: false},
              handleAuthResult);
            return false;
          }

          /**
           * Load Google Calendar client library. List upcoming events
           * once client library is loaded.
           */
          function loadCalendarApi() {
            gapi.client.load('calendar', 'v3', unhideUiElements);
          }

          /**
           * Print the summary and start datetime/date of the next ten events in
           * the authorized user's calendar. If no events are found an
           * appropriate message is printed.
           */

           function unhideUiElements() {
               $('.topbar').toggleClass("hidden");
               $('#sidebar').toggleClass("hidden");
               $('.container').toggleClass("hidden");
               console.log("You are authorized.");
               getSchedule();
           }
           function getSchedule() {
               var request = gapi.client.calendar.events.list({
                 'calendarId': 'primary',
                 'timeMin': "2015-11-22T00:00:00.000Z",
                 'showDeleted': false,
                 'singleEvents': true,
                 'maxResults': 80,
                 'orderBy': 'startTime'
               });
               var schedule = [];
               for(var j=0; j<7; j++){
                   schedule[j] = [];
                   for(var k=0; k<24; k++){
                       schedule[j][k] = 1;
                   }
               }
               request.execute(function(resp) {
                 var events = resp.items;
               //   appendPre('Upcoming events:');
                 var prevDay = 0;
                 if (events.length > 0) {
                   for (i = 0; i < events.length; i++) {
                     var event = events[i];
                     var dateObj = new Date(event.start.dateTime);
                     var day = dateObj.getDay();
                     var starttime;
                     var endtime;
                     if(event.start.dateTime !== undefined){
                         starttime = parseInt(event.start.dateTime.substring(11,13));
                         endtime = parseInt(event.end.dateTime.substring(11,13));
                         if(parseInt(event.end.dateTime[14]) == 0){
                             endtime--;
                         }
                     }
                     else {
                       starttime = 0;
                       endtime = 23;  
                     }
                     if(prevDay <= day){
                         for(var j=starttime; j<=endtime; j++){
                           schedule[day][j] = 0;
                         }
                       //   appendPre(event.summary + ' (' + "time: " + starttime + " - " + endtime + " day: " + day + ')');
                         prevDay = day;
                     }
                     else {
                         break;
                     }
                   }
                   var scheduleString = "";
                   for(var j=0; j<7; j++){
                       for(var k=0; k<24; k++){
                           scheduleString += schedule[j][k];
                       }
                   }
                   /* console.log(scheduleString); */
                 } else {
                   // appendPre('No upcoming events found.');
                   alert('No upcoming events found.');
                 }
               });
             }

          function listUpcomingEvents() {
            var request = gapi.client.calendar.events.list({
              'calendarId': 'primary',
              'timeMin': (new Date()).toISOString(),
              'showDeleted': false,
              'singleEvents': true,
              'maxResults': 10,
              'orderBy': 'startTime'
            });

            request.execute(function(resp) {
           		
              var events = resp.items;
              appendPre('Upcoming events:');

              if (events.length > 0) {
                for (i = 0; i < events.length; i++) {
                  var event = events[i];
                  var when = event.start.dateTime;
                  if (!when) {
                    when = event.start.date;
                  }
                  appendPre(event.summary + ' (' + when + ')')
                }
              } else {
                appendPre('No upcoming events found.');
              }

            });
          }

          /**
           * Append a pre element to the body containing the given message
           * as its text node.
           *
           * @param {string} message Text to be placed in pre element.
           */
          function appendPre(message) {
            var pre = document.getElementById('output');
            var textContent = document.createTextNode(message + '\n');
            pre.appendChild(textContent);
          }

          function addOrganization() {
            if($('#org-name-input').val().length > 0){
            	var orgdata = {
            			"orgName": $('#org-name-input').val(),
            			"nameCreatorID": "17"
            	};
            	
            	var posting = $.post( 'http://localhost:8080/Planit/addOrganization', JSON.stringify(orgdata), function(data, status){
					console.log(data);
			  		$('#sidebar').append("<div id='" + data.substr(0, data.length-1) + "' class='organization'>" + $('#org-name-input').val() + "</div>");
				  	
            	});
				
				/* posting.done( function( data ) {
					
					console.log(data);
					
				  	if(data.length > 1) {
				  		 $('#sidebar').append("<div id='4' class='organization'>" + $('#org-name-input').val() + "</div>");
				  	}
				  	
				  	
				  	
				  	//var idpost = $.post('http://localhost:8080/Planit/clickOrganization', id);
				}); */
				
				
            }
          }
			
          function getOrganizations() {
        	  $.get("http://localhost:8080/Planit/getOrganization", function(data){
        		  var orgs = JSON.parse(data).organizations;
        		  console.log(orgs);
        		  for(org in orgs){
        			  $("#organizations").append(
           				  "<div id='" + orgs[org].idOrganization + "' class='organization'>" +
                              orgs[org].nameOrganization + 
                          "</div>"  
            		  );
        		  }
        		  
        		 
        	  });
          }
          
          $(document).ready(function () {
        	  getOrganizations();
        	});
          
          
        </script>
        <script src="https://apis.google.com/js/client.js?onload=checkAuth">
        </script>
    </head>

    <body>
        <div id="authorize-div" style="display: none">
         <img src="Planit.png"/>
         <!--Button for the user to click to initiate auth sequence -->
         <button id="authorize-button" onclick="handleAuthClick(event)">
           Login
         </button>
        </div>
        <pre id="output"></pre>
        <div class="topbar hidden">
            <div class="logo"></div>
            <div id="profile-link">Profile</div>
        </div>
        <div id="sidebar" class="hidden">
            <div id="organizations">
                
            </div>
            <div id="new-org">
                + Organization
            </div>
        </div>
        <div class="container hidden">
            <div class="main">
                <div id="invites">
                    <div class="invite">
                        <div class="invite-title">
                            Invite Title
                        </div>
                        <div class="invite-deadline">
                            Deadline
                        </div>
                        <div class="opt-buttons">
                            <div class="opt-out">
                                Opt-Out
                            </div>
                            <div class="opt-in">
                                Opt-In
                            </div>
                        </div>
                    </div>
                    <!-- Additional Invites -->
                    <div class="invite">
                        <div class="invite-title">
                            Invite Title
                        </div>
                        <div class="invite-deadline">
                            Deadline
                        </div>
                        <div class="opt-buttons">
                            <div class="opt-out">
                                Opt-Out
                            </div>
                            <div class="opt-in">
                                Opt-In
                            </div>
                        </div>
                    </div>
                    <div class="invite">
                        <div class="invite-title">
                            Invite Title
                        </div>
                        <div class="invite-deadline">
                            Deadline
                        </div>
                        <div class="opt-buttons">
                            <div class="opt-out">
                                Opt-Out
                            </div>
                            <div class="opt-in">
                                Opt-In
                            </div>
                        </div>
                    </div>
                    <div id="new-invite">
                        + Invite
                    </div>
                </div>
            </div>
            <div id="nom" class="modal hidden">
                <div id="new-org-modal">
                    <div class="modal-instructions">
                        Enter organization name:
                    </div>
                    <input id="org-name-input" type="text" class="modal-text" placeholder="Organization Name">
                    <div class="modal-instructions">
                        Enter member emails (separated by spaces):
                    </div>
                    <input type="text" class="modal-text" placeholder="Email Addresses">
                    <br>
                    <div id="new-org-cancel" class="modal-button">
                        Cancel
                    </div>
                    <div id="new-org-confirm" class="modal-button">
                        Confirm
                    </div>
                </div>
            </div>
            <div id="nim" class="modal hidden">
                <div id="new-invite-modal">
                    <div class="modal-instructions">
                        Enter invite name:
                    </div>
                    <input type="text" class="modal-text" placeholder="Organization Name">
                    <div class="modal-instructions">
                        Enter invite deadline:
                    </div>
                    <div class="mdy-month">
                        Month:
                    </div>
                    <div class="mdy-day">
                        Day:
                    </div>
                    <div class="mdy-year">
                        Year:
                    </div>
                    <br>
                    <input class="date-combo" type=text list=months>
                    <select id=months>
                       <option> 1
                       <option> 2
                       <option> 3
                       <option> 4
                       <option> 5
                       <option> 6
                       <option> 7
                       <option> 8
                       <option> 9
                       <option> 10
                       <option> 11
                       <option> 12
                    </select>
                    <input class="date-combo" type=text list=days>
                    <select id=days>
                       <option> 1
                       <option> 2
                       <option> 3
                       <option> 4
                       <option> 5
                       <option> 6
                       <option> 7
                       <option> 8
                       <option> 9
                       <option> 10
                       <option> 11
                       <option> 12
                       <option> 13
                       <option> 14
                       <option> 15
                       <option> 16
                       <option> 17
                       <option> 18
                       <option> 19
                       <option> 20
                       <option> 21
                       <option> 22
                       <option> 23
                       <option> 24
                       <option> 25
                       <option> 26
                       <option> 27
                       <option> 28
                       <option> 29
                       <option> 30
                       <option> 31
                    </select>
                    <input class="date-combo" type=text list=years>
                    <select id=years>
                       <option> 2015
                       <option> 2016
                       <option> 2017
                       <option> 2018
                       <option> 2019
                       <option> 2020
                       <option> 2021
                       <option> 2022
                       <option> 2023
                       <option> 2024
                       <option> 2025
                       <option> 2026
                    </select>
                    <br>
                    <div id="new-invite-cancel" class="modal-button">
                        Cancel
                    </div>
                    <div id="new-invite-confirm" class="modal-button">
                        Confirm
                    </div>
                </div>
            </div>
        </div>

       
        <script src="main.js"></script>

    </body>
</html>
