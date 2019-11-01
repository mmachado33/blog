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

  <div class="header">
  	<h1>0 errors = perfect code</h1>
  </div>
  
  <div class="container">
  	<p>This is the homework 4 blog that Matthew and Adriana created.
  	   Matthew and Adriana have been dating for 3.5 years and have one boy,
  	   a marmalade boy named Riot.
  	</p>
<%

    pageContext.setAttribute("guestbookName", "default");

    UserService userService = UserServiceFactory.getUserService();

    User user = userService.getCurrentUser();

    if (user != null) {

      pageContext.setAttribute("user", user);

%>

<%
	if(pageContext.getAttribute("user") != null){
		%>
		
        <form action="/post.jsp" method="post">
      		<div><input type="submit" value="Create New Post" /></div>
    	</form>
		<% 
	}
	%>
<p>Hello, ${fn:escapeXml(user.nickname)}! (You can

<a href="<%= userService.createLogoutURL(request.getRequestURI()) %>">sign out</a>.)</p>

<%

    } else {

%>

<p>Please <a href="<%= userService.createLoginURL(request.getRequestURI()) %>">sign in</a>

to post on this blog.</p>
<%

    }

%>

 
  </div>

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
        	
        	%>
        	
        	<div class="post">
        	<%
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

                <div class="user">${fn:escapeXml(greeting_user.nickname)}</div> <div style="font-size:15px"> wrote at</div> <div class="datetime">${fn:escapeXml(greeting_date)}:</div>

                <%

            %>

            <blockquote class="posttitle">${fn:escapeXml(greeting_title)}</blockquote>
            
            <blockquote class="postbody">${fn:escapeXml(greeting_content)}</blockquote>
            
            </div>
			<p style="background-color:#EAABAB">
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
</div>
 
  

 

  </body>

</html>