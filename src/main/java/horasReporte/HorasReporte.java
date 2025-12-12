package horasReporte;

public class HorasReporte {
    private int idUsuario;
    private String nombreUsuario;
    private String apellidoUsuario;
    private int horas;
    private int idProyecto;
    private String nombreProyecto;
    private int idEtapa;
    private String nombreEtapa;
    private int idTarea;
    private String nombreTarea;
    
	public int getIdProyecto() {
		return idProyecto;
	}
	public void setIdProyecto(int idProyecto) {
		this.idProyecto = idProyecto;
	}
	public String getNombreProyecto() {
		return nombreProyecto;
	}
	public void setNombreProyecto(String nombreProyecto) {
		this.nombreProyecto = nombreProyecto;
	}
	public int getIdEtapa() {
		return idEtapa;
	}
	public void setIdEtapa(int idEtapa) {
		this.idEtapa = idEtapa;
	}
	public String getNombreEtapa() {
		return nombreEtapa;
	}
	public void setNombreEtapa(String nombreEtapa) {
		this.nombreEtapa = nombreEtapa;
	}
	public int getIdTarea() {
		return idTarea;
	}
	public void setIdTarea(int idTarea) {
		this.idTarea = idTarea;
	}
	public String getNombreTarea() {
		return nombreTarea;
	}
	public void setNombreTarea(String nombreTarea) {
		this.nombreTarea = nombreTarea;
	}
	public int getIdUsuario() {
		return idUsuario;
	}
	public void setIdUsuario(int idUsuario) {
		this.idUsuario = idUsuario;
	}
	public String getNombreUsuario() {
		return nombreUsuario;
	}
	public void setNombreUsuario(String nombre) {
		this.nombreUsuario = nombre;
	}
	public String getApellidoUsuario() {
		return apellidoUsuario;
	}
	public void setApellidoUsuario(String apellido) {
		this.apellidoUsuario = apellido;
	}
	public int getHoras() {
		return horas;
	}
	public void setHoras(int horas) {
		this.horas = horas;
	}
    
}

