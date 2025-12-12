package proyectoHorasDTO;

public class ProyectoHoras {
	private int idProyecto;
	private int totalHoras;
 
	public int getIdProyecto() {
		return idProyecto;
	}
	public void setIdProyecto(int idProyecto) {
		this.idProyecto = idProyecto;
	}
	public int getTotalHoras() {
		return totalHoras;
	}
	public void setTotalHoras(int totalHoras) {
		this.totalHoras = totalHoras;
	}
	
	public ProyectoHoras(int idProyecto, int totalHoras) {
		super();
		this.idProyecto = idProyecto;
		this.totalHoras = totalHoras;
	}

	public ProyectoHoras() {
		super();
	}
	
}
