package etapas;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;
import exceptions.DAOException;
import proyectos.Proyecto;
import proyectos.ProyectoDAO;
import tareas.Tarea;
import tareas.TareaDAO;
import utils.ConexionDB;

public class EtapaDAO {
	
	public void insert(Etapa etapa) throws DAOException {
		String sql = "INSERT INTO etapa "
				+ "(nombre, descripcion, estado, fechaInicio, fechaFin, fechaTentativa, idProyecto;) VALUES (?, ?, ?, ?, ?, ?, ?)";
		
		try (Connection con = ConexionDB.getConexion();
	             PreparedStatement ps = con.prepareStatement(sql)) {

	            ps.setString(1, etapa.getNombre());
	            ps.setString(2, etapa.getDescripcion());
	            ps.setString(3, etapa.getEstado());
	            ps.setDate(4, new Date(etapa.getFechaInicio().getTime()));
	            ps.setDate(5, new Date(etapa.getFechaFin().getTime()));
	            ps.setDate(6, new Date(etapa.getFechaTentativa().getTime()));
	            ps.setInt(7, etapa.getProyecto().getId());
	            ps.executeUpdate();

	        } catch (SQLException e) {
	        	throw new DAOException("Error al insertar la etapa: "+ etapa.getNombre(), e);
	        }
	}
	
	public void update(Etapa etapa) throws DAOException{
		 String sql = "UPDATE etapa SET nombre = ?, descripcion = ?, "
		 		+ "	SET estado = ?, SET fechaInicio = ?, SET fechaFin = ?, SET fechaTentativa = ?"
		 		+ " WHERE id = ?";
		 
		 try (Connection con = ConexionDB.getConexion();
	             PreparedStatement ps = con.prepareStatement(sql)) {

	            ps.setString(1, etapa.getNombre());
	            ps.setString(2, etapa.getDescripcion());
	            ps.setString(3, etapa.getEstado());
	            ps.setDate(4, new Date(etapa.getFechaInicio().getTime()));
	            ps.setDate(5, new Date(etapa.getFechaFin().getTime()));
	            ps.setDate(6, new Date(etapa.getFechaTentativa().getTime()));
	            ps.setInt(7, etapa.getProyecto().getId());
	            ps.executeUpdate();

	        } catch (SQLException e) {
	        	throw new DAOException("Error al actualizar la etapa: "+ etapa.getNombre(), e);
	        }
	}
	
	public void delete(int id) throws DAOException {
		String sql = "DELETE FROM etapa WHERE id = ?";
		
		try (Connection con = ConexionDB.getConexion();
	             PreparedStatement ps = con.prepareStatement(sql)) {
				ps.setInt(1, id);
	            ps.executeUpdate();

	        } catch (SQLException e) {
	        	throw new DAOException("Error al eliminar la etapa con id: "+ id, e);
	        }
	}
	
	public Etapa getOne(int id) throws DAOException{
		String sql = "SELECT etapa.*, tarea.id as tarea_id FROM etapa LEFT JOIN tarea ON etapa.id = tarea.idEtapa WHERE id = ?";
		Etapa etapa = null;
		List<Tarea> tareas = new ArrayList<>();
		
		try (Connection con = ConexionDB.getConexion();
	       PreparedStatement ps = con.prepareStatement(sql)) {
			
			ps.setInt(1, id);
	        try (ResultSet rs = ps.executeQuery()) {

	            ProyectoDAO pdao = new ProyectoDAO();
	            TareaDAO tdao = new TareaDAO();

	            while (rs.next()) {
	                // Primera vez: crear la etapa
	                if (etapa == null) {
	                    etapa = new Etapa();
	                    etapa.setId(rs.getInt("id"));
	                    etapa.setNombre(rs.getString("nombre"));
	                    etapa.setDescripcion(rs.getString("descripcion"));
	                    etapa.setEstado(rs.getString("estado"));
	                    etapa.setFechaInicio(rs.getDate("fechaInicio"));
	                    etapa.setFechaFin(rs.getDate("fechaFin"));
	                    etapa.setFechaTentativa(rs.getDate("fechaTentativa"));

	                    int idProyecto = rs.getInt("idProyecto");
	                    if (idProyecto > 0) {
	                        etapa.setProyecto(pdao.getById(idProyecto));
	                    }
	                }

	                // Si hay tarea (puede ser NULL en LEFT JOIN)
	                Integer tareaId = rs.getInt("tarea_id");
	                if (!rs.wasNull()) {
	                    Tarea tarea = tdao.getOne(tareaId); // para simplificar el codigo
	                    tareas.add(tarea);
	                }
	            }

	            if (etapa != null) {
	                etapa.setTareas(tareas);
	            }
	        }
		} catch (SQLException e) {
        	throw new DAOException("Error al eliminar la etapa con id: "+ id, e);
        }
		return etapa;

	}
	
	public List<Etapa> getAll() throws DAOException{
		String sql = "SELECT etapa.*, tarea.id as tarea_id FROM etapa LEFT JOIN tarea ON etapa.id = tarea.idEtapa";
		List<Etapa> etapas = new ArrayList<>();
		List<Tarea> tareas = new ArrayList<>();
		
		try (Connection con = ConexionDB.getConexion();
				Statement st = con.createStatement();
				ResultSet rs = st.executeQuery(sql)) {
            while (rs.next()) {
            	Etapa etapa = new Etapa();
            	etapa.setId(rs.getInt("id"));
                etapa.setNombre(rs.getString("nombre"));
                etapa.setDescripcion(rs.getString("descripcion"));
                etapa.setEstado(rs.getString("estado"));
                etapa.setFechaInicio(rs.getDate("fechaInicio"));
                etapa.setFechaFin(rs.getDate("fechaFin"));
                etapa.setFechaTentativa(rs.getDate("fechaTentativa"));
                
                ProyectoDAO pdao = new ProyectoDAO();
                Proyecto pro = pdao.getById(rs.getInt("idProyecto"));
                etapa.setProyecto(pro);
                
                // Si hay tarea (puede ser NULL en LEFT JOIN)
                TareaDAO tdao = new TareaDAO();
                Integer tareaId = rs.getInt("tarea_id");
                if (!rs.wasNull()) {
                    Tarea tarea = tdao.getOne(tareaId); // para simplificar el codigo
                    tareas.add(tarea);
                }
                //falta agregar que se traiga las tareas
                
                etapas.add(etapa);
            }
		} catch (SQLException e) {
        	throw new DAOException("Error al obtener todas las etapas ", e);
       }
		
	return etapas;
	} 
	

}

