package etapas;
import java.sql.Date;
import java.util.List;

import proyectos.Proyecto;
import tareas.Tarea;

public class Etapa {
	private int id;
	private String nombre;
	private String descripcion;
	private String estado; //pendiente, finalizada, etc
	private Date fechaInicio;
	private Date fechaFin;
	private Date fechaTentativa;
	private Proyecto proyecto;
	private List<Tarea> tareas;
	
	public int getId() {
		return id;
	}
	public void setId(int id) {
		this.id = id;
	}
	
	public String getNombre() {
		return nombre;
	}

	public void setNombre(String nombre) {
		this.nombre = nombre;
	}

	public String getDescripcion() {
		return descripcion;
	}

	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
	}

	public String getEstado() {
		return estado;
	}

	public void setEstado(String estado) {
		this.estado = estado;
	}

	public Date getFechaInicio() {
		return fechaInicio;
	}

	public void setFechaInicio(Date fechaInicio) {
		this.fechaInicio = fechaInicio;
	}

	public Date getFechaFin() {
		return fechaFin;
	}

	public void setFechaFin(Date fechaFin) {
		this.fechaFin = fechaFin;
	}

	public Date getFechaTentativa() {
		return fechaTentativa;
	}

	public void setFechaTentativa(Date fechaTentativa) {
		this.fechaTentativa = fechaTentativa;
	}

	public Proyecto getProyecto() {
		return proyecto;
	}

	public void setProyecto(Proyecto proyecto) {
		this.proyecto = proyecto;
	}
	
	
	public List<Tarea> getTareas() {
		return tareas;
	}
	
	public void setTareas(List<Tarea> tareas) {
		this.tareas = tareas;
	}
	
	// Constructor
	public Etapa() {
		super();
	}

}
