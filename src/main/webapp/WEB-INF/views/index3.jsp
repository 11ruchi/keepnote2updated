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

<title>Keep-Board</title>
</head>

<body>
	<!-- Create a form which will have text boxes for Note title, content and status along with a Add 
		 button. Handle errors like empty fields.  (Use dropdown-list for NoteStatus) -->
		 
		 <div class="well well-sm">
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
		 </div>
		
		 <c:choose>
		 
		 <c:when test="${editNote eq null}">
		 <h2 class="text-primary ml-3">Add Note</h2>
		 <form:form action="add" method="post" modelAttribute="note">
		 <div class="ml-3">
		 <div class="form-row">
		 <div class="form-group col-md-3">
		 <label for="noteTitle">Note Title</label>
		 <span class="text-danger">*</span>
		 <form:input path="noteTitle" class="form-control" id="noteTitle"
		 placeholder="Note Title" />
		 
		 </div>
		 
		 <div class="form-group col-md-3">
		 <label for="noteContent">Note Content</label>
		 <span class="text-danger">*</span>
		 <form:input path="noteContent" class="form-control" id="noteContent" 
		 placeholder="Note Content" />
		 
		 </div>
		 
		 </div>
		 <div class="form-row">
		 <c:if test="${not empty noteStatusList}">
		 <div class="form-group col-md-3">
		 <label for="noteStatus">Note Status</label>
		 <span class ="text-danger">*</span>
		 <form:select path="noteStatus" class="form-control"
		  id="noteStatus" placeholder="Note Status">
		 <c:forEach var="noteStatus" items="${noteStatusList}">
		 <option>${noteStatus} </option>
		 </c:forEach>
		 </form:select>
		 </div>
		 </c:if>
		 </div>
		 <button type ="submit" class="btn btn-primary">Add</button>
		 <button type ="reset" class="btn btn-primary">Clear</button>
		 </div>
		 </form:form>
   </c:when>
   
   <c:otherwise>
   <h2 class="text-primary ml-3">Edit Note</h2>
   <form:form action="update" method="post" modelAttribute="editNote">
   <form:input path="hidden" path="noteId" value="${editNote.noteId }"/>
   <div class="ml-3">
   <div class="form-row">
   <div class="form-group col-md-3">
   <label for="noteTitle">Note Title</label>
   <span class ="text-danger">*</span>
   <form:input path="noteTitle" value="${editNote.noteTitle}" 
   class="form-control" id="noteTitle" placeholder="Note Title"/>
   </div>
   <div class = "form-group col-md-3">
   <label for="noteContent">Note Content</label>
   <span class ="text-danger">*</span>
   <form:input path="noteContent" value="${editNote.noteContent}" 
   class="form-control" id="noteContent" placeholder="Note Content"/>
   
   </div>
   </div>
 
   <div class="form-row">
   <div class="form-group col-md-3">
   <label for="noteTitle">Note Status</label>
   <span class ="text-danger">*</span>
   <form:select path="noteStatus"  class="form-control" id="noteStatus" placeholder="Note Status">
   <form:option value="-"
   selected="${editNote.noteStatus eq \"-\"? \"selected\" :\"\"}">select from options</form:option>
   
    <form:option value="started"
   selected="${editNote.noteStatus eq \"started\"? \"selected\" :\"\"}">Started</form:option>
   
   <form:option value="not-started"
   selected="${editNote.noteStatus eq \"not-started\"? \"selected\" :\"\"}">Non Started</form:option>
   
   <form:option value="completed"
   selected="${editNote.noteStatus eq \"completed\"? \"selected\" :\"\"}">Completed</form:option>
   </form:select>
   </div>
   </div>
   <div class="form-row ml-1 mb-2">
   <button type="submit" class="btn btn-primary">Update</button>
   </div>
   </div>
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