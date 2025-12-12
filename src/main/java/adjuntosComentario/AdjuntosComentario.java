package adjuntosComentario;

public class AdjuntosComentario {

	    private int id;
	    private int idComentario;
	    private String nombreOriginal;
	    private String nombreGuardado;
	    private String ruta;
	    private int tamanoKb;
	    private String tipoMime;

	    // getters y setters 
	    public int getId() { return id; }
	    
	    public void setId(int id) { this.id = id; }
	    
	    public int getIdComentario() { return idComentario; }
	    
	    public void setIdComentario(int idComentario) { this.idComentario = idComentario; }
	    
	    public String getNombreOriginal() { return nombreOriginal; }
	    
	    public void setNombreOriginal(String nombreOriginal) { this.nombreOriginal = nombreOriginal; }
	    
	    public String getNombreGuardado() { return nombreGuardado; }
	    
	    public void setNombreGuardado(String nombreGuardado) { this.nombreGuardado = nombreGuardado; }
	    
	    public String getRuta() { return ruta; }
	    
	    public void setRuta(String ruta) { this.ruta = ruta; }
	    
	    public int getTamanoKb() { return tamanoKb; }
	    
	    public void setTamanoKb(int tamanoKb) { this.tamanoKb = tamanoKb; }
	    
	    public String getTipoMime() { return tipoMime; }
	    
	    public void setTipoMime(String tipoMime) { this.tipoMime = tipoMime; }
	}
	
