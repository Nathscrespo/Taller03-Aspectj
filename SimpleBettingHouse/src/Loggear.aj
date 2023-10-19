import java.io.BufferedWriter;
import java.io.File;
import java.io.FileWriter;
import java.io.*;
import java.io.PrintWriter;
import java.time.LocalDateTime;
import java.util.Calendar;

import com.bettinghouse.*;

public aspect Loggear {
	//Archivo Loggear
	 File file = new File("Register.txt");
	 Calendar cal;
	 pointcut success() : call(* successfulSignUp*(..) );
	    after() : success() {
	    //Aspecto ejemplo: solo muestra este mensaje despu�s de haber creado un usuario 
	    	System.out.println("** User created **");
	    }
	    
	    pointcut singUpPoint(User user, Person person): call(void successfulSignUp(User, Person)) && args(user, person);

	    after(User user, Person person) : singUpPoint(user, person) {
	     this.cal = Calendar.getInstance();
	     String contenido = "Usuario Registrado ->"+"[nickname = " +user.getNickname()+ 
	    		 ",password = "+user.getPassword()+ "] Fecha: ["+ cal.getTime() +"]";
	      try {
	       
	    	PrintWriter pw=new PrintWriter(new FileOutputStream(file,true));
	        pw.println("\n"+contenido);	        
	    	pw.close();
	    	System.out.println(contenido);
	      } catch (IOException e) {
	        System.out.println("Error al guardar información en archivo: " + e.getMessage());
	      }
	    
	    }

}