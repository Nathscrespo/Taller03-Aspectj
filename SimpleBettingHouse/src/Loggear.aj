import java.io.BufferedWriter;
import java.io.File;
import java.io.FileWriter;
import java.io.*;
import java.io.PrintWriter;
import java.text.SimpleDateFormat;
import java.time.LocalDateTime;
import java.util.Calendar;

import com.bettinghouse.*;

public aspect Loggear {
	//Archivo Loggear
	 private SimpleDateFormat fecha = new SimpleDateFormat("EEE MMM dd HH:mm:ss z yyyy");
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
	    
	    private void recordAction(String fileName, User user, String actionType) {
			File file = new File(fileName);
			String time = fecha.format(Calendar.getInstance().getTime());

			try (PrintWriter out = new PrintWriter(new FileWriter(file, true))) {
			String message;
			if (actionType.equals("Usuario registrado")) {
			message = actionType + ": [nickname=" + user.getNickname() + ", password=" + user.getPassword() + "] Fecha: [" + time + "]";
			} else {
			message = actionType + " por usuario: [" + user.getNickname() + "] Fecha: [" + time + "]";
			}
			System.out.println(message);
			out.println(message);
			} catch (IOException e) {
			e.printStackTrace();
			}
		}
		
	    
	    pointcut loginAndLogoutUser() : (call(* com.bettinghouse.BettingHouse.effectiveLogIn(..)) || call(* com.bettinghouse.BettingHouse.effectiveLogOut(..)));

		after() returning : loginAndLogoutUser() {
			User user = (User)thisJoinPoint.getArgs()[0];
			if (thisJoinPoint.getSignature().getName().equals("effectiveLogIn")) {
				recordAction("Log.txt", user, "Sesión iniciada");
			} else if (thisJoinPoint.getSignature().getName().equals("effectiveLogOut")) {
				recordAction("Log.txt", user, "Sesión cerrada");
			}
		}

}