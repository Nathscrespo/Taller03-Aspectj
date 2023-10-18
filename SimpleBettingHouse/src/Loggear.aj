

public aspect Loggear {
	//Archivo Loggear
		
	 pointcut success() : call(* successfulSignUp*(..) );
	    after() : success() {
	    //Aspecto ejemplo: solo muestra este mensaje despu�s de haber creado un usuario 
	    	System.out.println("**** User created ****");
	    }
}
