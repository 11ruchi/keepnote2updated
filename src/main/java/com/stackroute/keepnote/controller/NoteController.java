package com.stackroute.keepnote.controller;

import java.time.LocalDateTime;
import java.util.Arrays;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.util.StringUtils;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.stackroute.keepnote.dao.NoteDAO;
import com.stackroute.keepnote.model.Note;

/*
 * Annotate the class with @Controller annotation.@Controller annotation is used to mark 
 * any POJO class as a controller so that Spring can recognize this class as a Controller
 */
@Controller
public class NoteController {
	/*
	 * From the problem statement, we can understand that the application requires
	 * us to implement the following functionalities.
	 * 
	 * 1. display the list of existing notes from the persistence data. Each note
	 * should contain Note Id, title, content, status and created date. 
	 * 2. Add a new note which should contain the note id, title, content and status. 
	 * 3. Delete an existing note 
	 * 4. Update an existing note
	 * 
	 */
	
	@Autowired
	private NoteDAO noteDao;

	/*
	 * Autowiring should be implemented for the NoteDAO.
	 * Create a Note object.
	 * 
	 */
   public  NoteController(NoteDAO noteDao) {
	   super();
	   this.noteDao = noteDao;
   }
   
   private List<String> noteStatusList = Arrays.asList("select from options","not-started","started","completed");
   
	/*
	 * Define a handler method to read the existing notes from the database and add
	 * it to the ModelMap which is an implementation of Map, used when building
	 * model data for use with views. it should map to the default URL i.e. "/index"
	 */

   public  String getAllNotes(final ModelMap model,@ModelAttribute("note") Note note, BindingResult result) {
	   model.addAttribute("noteStatusList", noteStatusList);
	   model.addAttribute("notesList",noteDao.getAllNotes());
	   note = new Note();
	   return "index";
   }
	/*
	 * Define a handler method which will read the NoteTitle, NoteContent,
	 * NoteStatus from request parameters and save the note in note table in
	 * database. Please note that the CreatedAt should always be auto populated with
	 * system time and should not be accepted from the user. Also, after saving the
	 * note, it should show the same along with existing messages. Hence, reading
	 * note has to be done here again and the retrieved notes object should be sent
	 * back to the view using ModelMap This handler method should map to the URL
	 * "/add".
	 */
      @PostMapping(value="/add")
      public String addNote(@ModelAttribute("note") final Note note, final ModelMap map,
    		  final BindingResult result, final RedirectAttributes redirectAttrs) {
    	  String view = "index";
    	  if(StringUtils.isEmpty(note.getNoteId())) {
    		  result.reject("noteId", "Enter Note Id");
        }
    	  if(StringUtils.isEmpty(note.getNoteTitle())) {
    		  result.reject("noteTitle", "Enter Note Title");
        }
    	  if(StringUtils.isEmpty(note.getNoteContent())) {
    		  result.reject("noteContent", "Enter Note Content");
        }
    	  if(result.hasErrors()) {
    		  map.addAttribute("errorMsg", "Please Enter all the required fields");
    		  map.addAttribute("note", note);
    	  } else {
    		  final Note getNote = noteDao.getNoteById(note.getNoteId());
    		  if(getNote != null) {
    			  getNote.setNoteContent(note.getNoteContent());
    			  getNote.setNoteTitle(note.getNoteTitle());
    			  getNote.setNoteStatus(note.getNoteStatus());
    			  noteDao.UpdateNote(getNote);
    			  redirectAttrs.addFlashAttribute("successMsg", "Note updated successfully");
    			  
    		  }else {
    			  note.setCreatedAt(LocalDateTime.now());
    			  noteDao.saveNote(note);
    			  redirectAttrs.addFlashAttribute("successMsg", "Note added successfully");
    			  
    		  }
    		  redirectAttrs.addFlashAttribute("errorMsg", "");
    		  map.addAttribute("note", new Note());
    		  view= "redirect:/";
    	  }
    	  map.addAttribute("notes", noteDao.getAllNotes());
    	  return view;
      }
	/*
	 * Define a handler method which will read the NoteId from request parameters
	 * and remove an existing note by calling the deleteNote() method of the
	 * NoteRepository class.This handler method should map to the URL "/delete".
	 */
      @GetMapping(path="/delete")
      public String deleteNote(@RequestParam("noteId") final int noteId, final RedirectAttributes redirectAttrs) {
      boolean result = noteDao.deleteNote(noteId);
      if(result)
    	  redirectAttrs.addFlashAttribute("successMsg", "Note Delete successfully");
      else
    	  redirectAttrs.addFlashAttribute("errorMsg", "Error Occured deleting note");
      return "redirect:/";
      }
	/*
	 * Define a handler method which will update the existing note. This handler
	 * method should map to the URL "/update".
	 */
      @PostMapping(path="/update")
      public String updateNote(@ModelAttribute("note") final Note note, final RedirectAttributes redirectAttrs) {
      boolean result = noteDao.UpdateNote(note);
      if(result)
    	  redirectAttrs.addFlashAttribute("successMsg", "Note updated successfully");
      else
    	  redirectAttrs.addFlashAttribute("errorMsg", "Error Occured updated Note");
      return "redirect:/";
      }
      
      @GetMapping(path="/getNoteById")
      public String getNoteById(@RequestParam("noteId")int noteId,ModelMap map) {
    	  Note editNote = noteDao.getNoteById(noteId);
    	  if(editNote != null) {
    		  map.addAttribute("noteList", noteDao.getAllNotes());
    		  map.addAttribute("editNote",editNote);
    		  return "index";
    	  }
    	  return "redirect:/";
      }
}