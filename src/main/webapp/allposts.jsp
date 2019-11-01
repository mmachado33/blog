<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%@ page import="java.util.List" %>
<%@ page import="java.util.Collections" %>
<%@ page import="guestbook.Greeting" %>

<%@ page import="com.google.appengine.api.users.User" %>

<%@ page import="com.google.appengine.api.users.UserService" %>

<%@ page import="com.google.appengine.api.users.UserServiceFactory" %>

<%@ page import="com.google.appengine.api.datastore.DatastoreServiceFactory" %>

<%@ page import="com.google.appengine.api.datastore.DatastoreService" %>

<%@ page import="com.google.appengine.api.datastore.Query" %>

<%@ page import="com.google.appengine.api.datastore.Entity" %>

<%@ page import="com.google.appengine.api.datastore.FetchOptions" %>

<%@ page import="com.google.appengine.api.datastore.Key" %>

<%@ page import="com.google.appengine.api.datastore.KeyFactory" %>
<%@ page import="com.googlecode.objectify.*" %>

<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

 

<html>

  <head>
   <link type="text/css" rel="stylesheet" href="/stylesheets/main.css" />
 </head>


 

  <body>
 

<%

ObjectifyService.register(Greeting.class);

List<Greeting> greetings = ObjectifyService.ofy().load().type(Greeting.class).list();   

Collections.sort(greetings); 

    if (greetings.isEmpty()) {

        %>

        <h1>There are no posts.</h1>

        <%

    } else {

        %>

        <h1>All Blog Posts.</h1>

		<div class="post">
        <%

        for (Greeting greeting : greetings) {
        	if(greeting.getTitle() != null) {
				pageContext.setAttribute("greeting_title", greeting.getTitle());
				
			} else {
				pageContext.setAttribute("greeting_title", "<Untitled>");
			}
            pageContext.setAttribute("greeting_content",

                                     greeting.getContent());

            if (greeting.getUser() == null) {

                %>

                <p class="user">An anonymous person wrote:</p>

                <%

            } else {

                pageContext.setAttribute("greeting_user",

                                         greeting.getUser());

                %>

                <p><b>${fn:escapeXml(greeting_user.nickname)}</b> wrote:</p>

                <%

            }

            %>
			
			<blockquote class="posttitle">${fn:escapeXml(greeting_title)}</blockquote>
            
            <blockquote class="postbody">${fn:escapeXml(greeting_content)}</blockquote>
			
            <%

        }
      %>
      </div>
      <br>
      <%
    }

%> 

  </body>

</html>