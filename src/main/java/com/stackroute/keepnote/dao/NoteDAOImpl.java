package com.stackroute.keepnote.dao;

import java.util.List;

import javax.transaction.Transactional;

import org.hibernate.HibernateException;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.stackroute.keepnote.model.Note;

/*
 * This class is implementing the NoteDAO interface. This class has to be annotated with @Repository
 * annotation.
 * @Repository - is an annotation that marks the specific class as a Data Access Object, thus 
 * 				 clarifying it's role.
 * @Transactional - The transactional annotation itself defines the scope of a single database 
 * 					transaction. The database transaction happens inside the scope of a persistence 
 * 					context.  
 * */

@Repository
@Transactional
public class NoteDAOImpl implements NoteDAO {

	/*
	 * Autowiring should be implemented for the SessionFactory.
	 */
	@Autowired
    private SessionFactory sessionFactory;
    
	public NoteDAOImpl(SessionFactory sessionFactory) {
      this.sessionFactory = sessionFactory;
	}

	/*
	 * Save the note in the database(note) table.
	 */

	public boolean saveNote(Note note) {
		boolean isNoteSaved = false;
		try {
			Session session = this.sessionFactory.getCurrentSession();
			session.save(note);
			isNoteSaved = true;
		} catch (HibernateException e) {
			e.printStackTrace();
			// TODO: handle exception
		}
		return isNoteSaved;

	}

	/*
	 * Remove the note from the database(note) table.
	 */

	public boolean deleteNote(int noteId) {
		Note note = null;
		boolean isNoteDeleted = false;
		try {
			Session session = this.sessionFactory.getCurrentSession();
			note = (Note) session.load(Note.class, new Integer(noteId));
			if(null != note) {
				session.delete(note);
			}
			isNoteDeleted = true;
		} catch (HibernateException e) {
			// TODO: handle exception
			e.printStackTrace();
		}
		return isNoteDeleted;

	}

	/*
	 * retrieve all existing notes sorted by created Date in descending
	 * order(showing latest note first)
	 */
	@SuppressWarnings("unchecked")
	public List<Note> getAllNotes() {
		List<Note> notesList = null;
		try {
			Session session = this.sessionFactory.getCurrentSession();
			notesList = session.createQuery("from Note").list();
		} catch (HibernateException e) {
			// TODO: handle exception
			e.printStackTrace();
		}
		return notesList;

	}

	/*
	 * retrieve specific note from the database(note) table
	 */
	public Note getNoteById(int noteId) {
		Note note = null;
		try {
			Session session = this.sessionFactory.getCurrentSession();
			note = (Note) session.get(Note.class, new Integer(noteId));
		}catch(HibernateException e) {
			e.printStackTrace();
		}
		return note;

	}

	/* Update existing note */

	public boolean UpdateNote(Note note) {
		boolean isNoteUpdated = false;
		try {
		Session session = this.sessionFactory.getCurrentSession();
		session.merge(note);
		isNoteUpdated = true;
		} catch(HibernateException e) {
			e.printStackTrace();
		}
		return isNoteUpdated;

	}

}