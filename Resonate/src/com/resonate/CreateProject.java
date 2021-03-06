package com.resonate;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.StandardCopyOption;

import java.util.Vector;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Part;

import com.resonate.objects.Project;
import com.resonate.objects.User;

/**
 * Servlet implementation class CreateProject
 */
@WebServlet("/CreateProject")
@MultipartConfig
public class CreateProject extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public CreateProject() {
        super();
        // TODO Auto-generated constructor stub
    }

    protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
	    	String proj_name = request.getParameter("name");
	    	String proj_desc = request.getParameter("description");
	    	String proj_photo = null;
	    	String proj_genre = request.getParameter("genre");
	    	Vector<String> proj_resources = new Vector<String>();
	    	
	    	System.out.println(proj_name);
	    	System.out.println(proj_desc);
	    	
	    	
        HttpSession session = request.getSession();
        
        String root = Config.destinationPath + "/uploads";
        String filename;
        
        Part filePart = request.getPart("photo"); 

        if (filePart != null && !filePart.getSubmittedFileName().equals("")) {
	        filename = filePart.getSubmittedFileName();
	        proj_photo = filename;
	 
	        File path = new File(root + "/projectResources");
	        if (!path.exists()) {
	            boolean status = path.mkdirs();
	        }
	
	        File uploadedFile = new File(path + "/" + filename);
	        
	        try (InputStream input = filePart.getInputStream()) {
	            Files.copy(input, uploadedFile.toPath(), StandardCopyOption.REPLACE_EXISTING);
	        }
	
	        System.out.println("File uploaded to: " + uploadedFile.toPath());
        }
        
        int fileNum = 0;
        while((filePart = request.getPart("file_" + fileNum)) != null) {
	        	filename = filePart.getSubmittedFileName();
	        	if (filename.equals("")) continue; //Skip the blank ones.
       	 
	        File path = new File(root + "/projectResources");
	        if (!path.exists()) {
	            boolean status = path.mkdirs();
	        }
	
	        File uploadedFile = new File(path + "/" + filename);
	        
	        // TODO: This erases the file if it's name already exists
	        try (InputStream input = filePart.getInputStream()) {
	            Files.copy(input, uploadedFile.toPath(), StandardCopyOption.REPLACE_EXISTING);
	        }
	
	        System.out.println("File uploaded to: " + uploadedFile.toPath());
	        fileNum++;
        }
        
        User creator = (User)request.getSession().getAttribute("user");
        if (creator == null) {
	        	session.setAttribute("errorMessage", "Not Logged In");
	    		response.sendRedirect("/Resonate/createproject.jsp");
        }
        
        Project newProject = null;
        // TODO: Decide if we want the exception thing or if we just wanna do null thing hahaha...nullthing...nothing
        newProject = JDBCDriver.createProject(proj_name, proj_desc, proj_genre, proj_photo, proj_resources, creator);
        if (newProject != null) {
	        	// 	session.setAttribute("project", newProject); //TODO: Do we want this?
	        	System.out.println("Project Creation success.");
	        	response.sendRedirect("/Resonate/auditionstage.jsp?project=" + newProject.getId());
        } else {
        		session.setAttribute("errorMessage", "SQL Error");
        		response.sendRedirect("/Resonate/createproject.jsp");
        }
    }
}
