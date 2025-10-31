package tareas;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import categoriaTarea.CategoriaTarea;
import categoriaTarea.CategoriaTareaDAO;
//import etapas.Etapa;
//import etapas.EtapaDAO;
import exceptions.DAOException;
import utils.ConexionDB;

public class TareaDAO {

	 public void insert(Tarea tarea) throws DAOException {
	        String sql = "INSERT INTO tarea (nombre, descripcion, estado, fechaInicio, fechaFin, idEtapa, idCategoria) VALUES (?,?,?,?,?,?,?)";
	        try (Connection con = ConexionDB.getConexion();
	             PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
	        	
	            ps.setString(1, tarea.getNombre());
	            ps.setString(2, tarea.getDescripcion());
	            ps.setString(3, tarea.getEstado());
	            ps.setDate(4,new Date(tarea.getFechaInicio().getTime()));
	            ps.setDate(5, new Date(tarea.getFechaFin().getTime()));
	            ps.setInt(6, tarea.getIdEtapa());
	            ps.setInt(7, tarea.getCategoria().getId());
	            ps.executeUpdate();
	            try (ResultSet rs = ps.getGeneratedKeys()) {
	                if (rs.next()) {
	                    tarea.setId(rs.getInt(1));
	                }
	            }
	        } catch (SQLException e) {
	            throw new DAOException("Error al agregar la tarea: " + tarea.getNombre(), e);
	        }
	    }
	 
	 public void update(Tarea tarea) throws DAOException{
		 String sql = "UPDATE tarea SET nombre = ?, descripcion = ?, "
		 		+ "	SET estado = ?, SET fechaInicio = ?, SET fechaFin = ?, SET idEtapa = ?, SET idCategoria = ?"
		 		+ " WHERE id = ?";
		 
		 try (Connection con = ConexionDB.getConexion();
	             PreparedStatement ps = con.prepareStatement(sql)) {

			 	ps.setString(1, tarea.getNombre());
	            ps.setString(2, tarea.getDescripcion());
	            ps.setString(3, tarea.getEstado());
	            ps.setDate(4,new Date(tarea.getFechaInicio().getTime()));
	            ps.setDate(5, new Date(tarea.getFechaFin().getTime()));
	            ps.setInt(6, tarea.getIdEtapa());
	            ps.setInt(7, tarea.getCategoria().getId());
	            ps.executeUpdate();

	        } catch (SQLException e) {
	        	throw new DAOException("Error al actualizar la tarea: "+ tarea.getNombre(), e);
	        }
	 }
	 
		public void delete(int id) throws DAOException {
			String sql = "DELETE FROM tarea WHERE id = ?";
			
			try (Connection con = ConexionDB.getConexion();
		             PreparedStatement ps = con.prepareStatement(sql)) {
					ps.setInt(1, id);
		            ps.executeUpdate();

		        } catch (SQLException e) {
		        	throw new DAOException("Error al eliminar la tarea con id: "+ id, e);
		        }
		}
		
	public Tarea getOne(int id) throws DAOException{
			String sql = "SELECT * FROM tarea WHERE id = ?";
			Tarea tarea = null;
			
			try (Connection con = ConexionDB.getConexion();
		             PreparedStatement ps = con.prepareStatement(sql)) {
					ps.setInt(1, id);
					ResultSet rs = ps.executeQuery();

		            if (rs.next()) {
		            	tarea = new Tarea();
		            	tarea.setId(rs.getInt("id"));
		                tarea.setNombre(rs.getString("nombre"));
		                tarea.setDescripcion(rs.getString("descripcion"));
		                tarea.setEstado(rs.getString("estado"));
		                tarea.setFechaInicio(rs.getDate("fechaInicio"));
		                tarea.setFechaFin(rs.getDate("fechaFin"));
		                tarea.setIdEtapa(rs.getInt("idEtapa"));
		                
		                //para traer la categoriaTarea
		                CategoriaTareaDAO cdao = new CategoriaTareaDAO();
		                CategoriaTarea cat = cdao.getById(rs.getInt("idCategoria"));
		                tarea.setCategoria(cat);
		                
		            }
			} catch (SQLException e) {
	        	throw new DAOException("Error al eliminar la tarea con id: "+ id, e);
	        }
			return tarea;
		}

		public List<Tarea> getAll() throws DAOException{
			String sql = "SELECT * FROM tarea";
			List<Tarea> tareas = new ArrayList<>();
			
			try (Connection con = ConexionDB.getConexion();
					Statement st = con.createStatement();
					ResultSet rs = st.executeQuery(sql)) {
	            while (rs.next()) {
	            	Tarea tarea = new Tarea();
	            	tarea.setId(rs.getInt("id"));
	                tarea.setNombre(rs.getString("nombre"));
	                tarea.setDescripcion(rs.getString("descripcion"));
	                tarea.setEstado(rs.getString("estado"));
	                tarea.setFechaInicio(rs.getDate("fechaInicio"));
	                tarea.setFechaFin(rs.getDate("fechaFin"));
	                tarea.setIdEtapa(rs.getInt("idEtapa"));
	                //para traer la categoriaTarea
	                CategoriaTareaDAO cdao = new CategoriaTareaDAO();
	                CategoriaTarea cat = cdao.getById(rs.getInt("idCategoria"));
	                tarea.setCategoria(cat);
	            }
			} catch (SQLException e) {
	        	throw new DAOException("Error al obtener todas las tareas ", e);
	       }
			
		return tareas;
		} 
		
		public List<Tarea> getByEtapaId(int idEtapa) throws DAOException {
		    String sql = "SELECT * FROM tarea WHERE idEtapa = ? ORDER BY fechaInicio ASC"; // Orden lógico por fecha
		    List<Tarea> tareas = new ArrayList<>();
		    try (Connection con = ConexionDB.getConexion();
		         PreparedStatement ps = con.prepareStatement(sql)) {
		        ps.setInt(1, idEtapa);
		        ResultSet rs = ps.executeQuery();
		        while (rs.next()) {
		            Tarea tarea = new Tarea();
		            tarea.setId(rs.getInt("id"));
		            tarea.setNombre(rs.getString("nombre"));
		            tarea.setDescripcion(rs.getString("descripcion"));
		            tarea.setEstado(rs.getString("estado"));
		            tarea.setFechaInicio(rs.getDate("fechaInicio"));
		            tarea.setFechaFin(rs.getDate("fechaFin"));
		            tarea.setIdEtapa(rs.getInt("idEtapa")); // ID para referencia, sin cargar Etapa completa

		            // Cargar CategoriaTarea (como en tu getAll)
		            CategoriaTareaDAO cdao = new CategoriaTareaDAO();
		            CategoriaTarea cat = cdao.getById(rs.getInt("idCategoria"));
		            tarea.setCategoria(cat);

		            tareas.add(tarea);
		        }
		    } catch (SQLException e) {
		        throw new DAOException("Error al obtener tareas para etapa id: " + idEtapa, e);
		    }
		    return tareas;
		}

}
