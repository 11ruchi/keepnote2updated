<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8" isELIgnored="false"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="stylesheet"
	href="https://stackpath.bootstrapcdn.com/bootstrap/4.1.3/css/bootstrap.min.css"
	integrity="sha384-MCw98/SFnGE8fJT3GXwEOngsV7Zt27NXFoaoApmYm81iuXoPkFOJwJ8ERdknLPMO"
	crossorigin="anonymous">
<script src="https://code.jquery.com/jquery-3.3.1.slim.min.js"
	integrity="sha384-q8i/X+965DzO0rT7abK41JStQIAqVgRVzpbzo5smXKp4YfRvH+8abtTE1Pi6jizo"
	crossorigin="anonymous"></script>
<script
	src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.3/umd/popper.min.js"
	integrity="sha384-ZMP7rVo3mIykV+2+9J3UJ46jBk0WLaUAdn689aCwoqbBJiSnjAK/l8WvCWPIPm49"
	crossorigin="anonymous"></script>
<script
	src="https://stackpath.bootstrapcdn.com/bootstrap/4.1.3/js/bootstrap.min.js"
	integrity="sha384-ChfqqxuZUCnJSK3+MXmPNIyE6ZbWh2IMqE241rYiqJxyMiZ6OW/JmZQ5stwEULTy"
	crossorigin="anonymous"></script>


$(document).ready(function()){
$('.openEditPopup').on('click',function(){

var noteId=$(this).attr('data-target-id');
alert('id:'+noteId);
$.get('/keepNote-Step2-Boilerplate/getNoteById?noteId='  + noteId, function(data){

console.log(data.editNote);
console.log(data);
});

});

});
</script>


<title>Keep-Board</title>
</head>

<body>
	<!-- Create a form which will have text boxes for Note title, content and status along with a Add 
		 button. Handle errors like empty fields.  (Use dropdown-list for NoteStatus) -->
		 
	<!-- 	 <div class="well well-sm">
		 <c:if test="${!empty errorMsg }">
		 <div id="alert_error" class="alert alert-danger">
		 <a class="close" data-dismiss="alert">x</a> ${errorMsg }
		 <form:errors path="*" cssClass="error" element="div"/>
		 </div>
		 </c:if>
		 <c:if test="${!empty successMsg }">
		 <div id="alert_error" class="alert alert-success">
		 <a class="close" data-dismiss="alert">x</a> ${ successMsg }
		 </div>
		 </c:if>
		 </div>-->
		
		 <c:choose>
		 
		 <c:when test="${editNote eq null}">
		 <h2>Add Note</h2>
		 <form:form action="add" method="post" modelAttribute="note">
		 
		 <table>
		 <tr>
		 <td>Title :</td>
		 <td><form:input path="noteTitle"/></td>
		 </tr>
		 
		 <tr>
		 <td>Content :</td>
		 <td><form:textarea rows="2" cols="15" path="noteContent"></form:textarea></td>
		 		 </tr>
		 <tr>
		 <td>Status :</td>
		 <td><form:select path="noteStatus">
		 <form:option value="-">Select Option</form:option>
		  <form:option value="started">Started</form:option>
		   <form:option value="inprogress">Inprogress</form:option>
		    <form:option value="completed">Completed</form:option>
		    </form:select>
		   </tr>
		 
		<tr>
		 <td><input type ="submit" value=Add></td>
		 <td><input type ="reset" value=Clear></td>
		 </tr>
		 </table>
		 
		 </form:form>
   </c:when>
   
   <c:otherwise>
   
   <h2>Edit Note</h2>
   <form:form action="update" method="post" modelAttribute="editNote">
   <table>
    <form:input type="hidden" path="noteId" value="${editNote.noteId}" />
   <tr>
   <td> Title :</td>
   <td> <form:input path="noteTitle" value="${editNote.noteTitle}" /></td>
   </tr>
   
   <tr>
   <td> Content :</td>
   <td> <form:textarea rows="2" cols="15" path="noteContent" value="${editNote.noteContent}" ></form:textarea></td>
   </tr>
   
   <tr>
   <td> Status :</td>
   <td> <form:select path="noteStatus">
   <form:option value="-"
   selected="${editNote.noteStatus eq \"-\"? \"selected\" :\"\"}">select from options</form:option>
   
    <form:option value="started"
   selected="${editNote.noteStatus eq \"started\"? \"selected\" :\"\"}">Started</form:option>
   
   <form:option value="not-started"
   selected="${editNote.noteStatus eq \"not-started\"? \"selected\" :\"\"}">Non Started</form:option>
   
   <form:option value="completed"
   selected="${editNote.noteStatus eq \"completed\"? \"selected\" :\"\"}">Completed</form:option>
   </form:select>
   </td>
   </tr>
   <tr>
   <td></td>
   <td> <input type="submit"  value="update"></td>
   </tr>
   </table>
   </form:form>
   </c:otherwise>
   </c:choose>
	<!-- display all existing notes in a tabular structure with Title,Content,Status, Created Date and Action -->
<c:if test=${not empty notesList}">
<h2 class="text-primary ml-3">Notes List</h2>
<table class="table table-striped m-3">
<thead>
<tr>
<th scope="col">#</th>
<th scope="col">Note Title</th>
<th scope="col">Note Content</th>
<th scope="col">Note Status</th>
<th scope="col">Note Creation Date</th>
<th scope="col">Update</th>
<th scope="col">Delete</th>
</tr>
</thead>
<tbody>  
<c:forEach var="note" items="${notesList}">
<c:url value="delete" var="deleteUrl">
<c:param name="noteId" value ="${note.noteId }"/>
</c:url>
<c:url value="getNoteById" var="updateUrl">
<c:param name="noteId" value ="${note.noteId }"/>
</c:url>
<tr>
   <th scope="row">${note.noteId}</th>
   <td>${note.noteTitle}</td>
   <td>${note.noteContent}</td>
   <td>${note.noteStatus}</td>
   <td>${note.createdAt}</td>
   <td><a href="${updateUrl}">Update</a></td>
   <td><a href="${deleteUrl}">Delete</a></td>
   </tr>
   </c:forEach>
   </tbody>
   </table>
   </c:if>
   </body>
</html>