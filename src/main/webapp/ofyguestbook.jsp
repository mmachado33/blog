<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%@ page import="java.util.List" %>
<%@ page import="java.util.Collections" %>
<%@ page import="guestbook.Greeting" %>

<%@ page import="java.util.Date" %>
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

    pageContext.setAttribute("guestbookName", "default");

    UserService userService = UserServiceFactory.getUserService();

    User user = userService.getCurrentUser();

    if (user != null) {

      pageContext.setAttribute("user", user);

%>

<p>Hello, ${fn:escapeXml(user.nickname)}! (You can

<a href="<%= userService.createLogoutURL(request.getRequestURI()) %>">sign out</a>.)</p>

<%

    } else {

%>

<p>Hello!

<a href="<%= userService.createLoginURL(request.getRequestURI()) %>">Sign in</a>

to include your name with greetings you post.</p>

<%

    }

%>

 

<%

ObjectifyService.register(Greeting.class);

List<Greeting> greetings = ObjectifyService.ofy().load().type(Greeting.class).list();   

Collections.sort(greetings); 

    if (greetings.isEmpty()) {

        %>

        <p>There are no posts.</p>

        <%

    } else {

        %>

        <p>Most Recent Blog Posts.</p>

        <%

        for ( int i = 0; i< greetings.size(); i++) {
        	if(i>4){
        		break;
        	}
			Greeting greeting = greetings.get(i);
			
			if(greeting.getTitle() != null) {
				pageContext.setAttribute("greeting_title", greeting.getTitle());
				
			} else {
				pageContext.setAttribute("greeting_title", "<Untitled>");
			}
			
			pageContext.setAttribute("greeting_date", greeting.getDate().toString());
			
            pageContext.setAttribute("greeting_content",

                                     greeting.getContent());


                pageContext.setAttribute("greeting_user",

                                         greeting.getUser());

                %>

                <p><b>${fn:escapeXml(greeting_user.nickname)}</b> wrote at</p>
            
            	${fn:escapeXml(greeting_date)}:

                <%

            %>

            <blockquote>${fn:escapeXml(greeting_title)}</blockquote>
            
            <blockquote>${fn:escapeXml(greeting_content)}</blockquote>
            

            <%

        }
        if(greetings.size() > 4){
        	%>
        	<form action="/allposts.jsp" method="post">

      		<div><input type="submit" name="See All Posts" value="See All Posts" /></div>
    	</form>
		<% 
        }

    }

%>
<%
	if(pageContext.getAttribute("user") != null){
		%>
		
        <form action="/post.jsp" method="post">
      		<div><input type="submit" value="Create New Blog" /></div>
    	</form>
		<% 
	}
	%>
 
  

 

  </body>

</html>