package com.resonate;

import java.io.File;
import java.io.IOException;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.tomcat.util.http.fileupload.FileItem;
import org.apache.tomcat.util.http.fileupload.FileItemFactory;
import org.apache.tomcat.util.http.fileupload.FileUploadException;
import org.apache.tomcat.util.http.fileupload.RequestContext;
import org.apache.tomcat.util.http.fileupload.disk.DiskFileItemFactory;
import org.apache.tomcat.util.http.fileupload.servlet.ServletFileUpload;
import org.apache.tomcat.util.http.fileupload.servlet.ServletRequestContext;

import com.resonate.objects.*;

/**
 * Servlet implementation class CreateProject
 */
@WebServlet("/CreateProject")
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
    	ArrayList<String> proj_resources = new ArrayList<String>();
    	
    	//System.out.println(proj_name);
    	//System.out.println(proj_desc);
        HttpSession session = request.getSession();
        
        boolean isMultipart = ServletFileUpload.isMultipartContent(request);
        
        //System.out.println(isMultipart);

        if (isMultipart) {
            FileItemFactory factory = new DiskFileItemFactory();
            ServletFileUpload upload = new ServletFileUpload(factory);

            try {
                List items = upload.parseRequest(new ServletRequestContext(request));
                Iterator iterator = items.iterator();
                while (iterator.hasNext()) {
                    FileItem item = (FileItem) iterator.next();

                    if (!item.isFormField()) {
                        String fileName = item.getName();
                        
                        System.out.println(fileName);
                        
                        String root = "/Resonate/uploads";
                        File path = new File(root + "/projectResources");
                        if (!path.exists()) {
                            boolean status = path.mkdirs();
                        }

                        File uploadedFile = new File(path + "/" + fileName);
                        //System.out.println(uploadedFile.getAbsolutePath());
                        proj_resources.add(uploadedFile.getAbsolutePath());
                        
                        item.write(uploadedFile);
                    }
                }
            } catch (FileUploadException e) {
                e.printStackTrace();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        Project newProject = null;
        // newProject = JDBCDriver.createProject(proj_name, proj_desc, proj_resources);
        if (newProject != null) {
        	// session.setAttribute("project", newProject); //TODO: Do we want this?
        	response.sendRedirect("/Resonate/auditionstage.jsp");
        } else {
        	session.setAttribute("loginMessage", "SQL Error"); //TODO: Error?
        	response.sendRedirect("/Resonate/createproject.jsp");
        }
    }
}