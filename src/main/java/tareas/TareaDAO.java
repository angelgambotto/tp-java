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
import usuarios.Usuario;
import utils.ConexionDB;

public class TareaDAO {

	public void insert(Tarea tarea, List<Integer> usuarios) throws DAOException {
	    String sql = "INSERT INTO tarea (nombre, descripcion, estado, fechaInicio, fechaFin, idEtapa, idCategoria) VALUES (?,?,?,?,?,?,?)";
	    String sql2 = "INSERT INTO tarea_usuario (idTarea, idEmpleado) VALUES (?,?)";
	    
	    Connection con = null;
	    PreparedStatement ps = null;
	    PreparedStatement ps2 = null;
	    ResultSet rs = null;
	    
	    try {
	        con = ConexionDB.getConexion();
	        con.setAutoCommit(false);
	        
	        System.out.println("===== INSERTANDO RELACIONES =====");
	        System.out.println("Lista usuarios antes del if: " + usuarios);
	        
	       
	        ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
	        ps.setString(1, tarea.getNombre());
	        ps.setString(2, tarea.getDescripcion());
	        ps.setString(3, tarea.getEstado());
	        ps.setDate(4, new Date(tarea.getFechaInicio().getTime()));
	        ps.setDate(5, new Date(tarea.getFechaFin().getTime()));
	        ps.setInt(6, tarea.getIdEtapa());
	        ps.setInt(7, tarea.getIdCategoria());
	        ps.executeUpdate();
	        
	       
	        rs = ps.getGeneratedKeys();
	        if (rs.next()) {
	            System.out.println("El id de la tarea es: " + rs.getInt(1));
	            tarea.setId(rs.getInt(1));
	        }
	        
	 
	        ps2 = con.prepareStatement(sql2);
	        for (Integer idUsuario : usuarios) {
	            System.out.println("El id de la tarea es: " + tarea.getId());
	            System.out.println("El id del usuario es: " + idUsuario);
	            ps2.setInt(1, tarea.getId());
	            ps2.setInt(2, idUsuario);
	            ps2.executeUpdate();
	        }
	        
	        
	        con.commit();
	        System.out.println("transacción completada ");
	        
	    } catch (SQLException e) {
	       
	        if (con != null) {
	            try {
	                con.rollback();
	                System.out.println("✗ Rollback ejecutado debido a error");
	            } catch (SQLException ex) {
	                ex.printStackTrace();
	            }
	        }
	        e.printStackTrace();
	        throw new DAOException("Error al agregar la tarea: " + tarea.getNombre(), e);
	    } finally {
	        
	        try {
	            if (rs != null) rs.close();
	            if (ps != null) ps.close();
	            if (ps2 != null) ps2.close();
	            if (con != null) {
	                con.setAutoCommit(true);
	                con.close();
	            }
	        } catch (SQLException e) {
	            e.printStackTrace();
	        }
	    }
	}
	 
	 public void update(Tarea tarea, List<Integer> usuariosSeleccionados) throws DAOException {

		    String sqlUpdate = "UPDATE tarea SET nombre=?, descripcion=?, fechaInicio=?, fechaFin=?, idCategoria=?,estado=? WHERE id=?";
		    String sqlUsuariosActuales = "SELECT idEmpleado FROM tarea_usuario WHERE idTarea=?";
		    String sqlInsertUsuario = "INSERT INTO tarea_usuario (idTarea, idEmpleado) VALUES (?, ?)";
		    String sqlDeleteUsuario = "DELETE FROM tarea_usuario WHERE idTarea=? AND idEmpleado=?";

		    try {
		        Connection con=ConexionDB.getConexion();
		        PreparedStatement ps = con.prepareStatement(sqlUpdate);
		        ps.setString(1, tarea.getNombre());
		        ps.setString(2, tarea.getDescripcion());
		        ps.setDate(3, tarea.getFechaInicio());
		        ps.setDate(4, tarea.getFechaFin());
		        ps.setInt(5, tarea.getIdCategoria());
		        ps.setString(6, tarea.getEstado());
		        ps.setInt(7, tarea.getId());
		        ps.executeUpdate();
PreparedStatement psUsuariosAct = con.prepareStatement(sqlUsuariosActuales);
		        psUsuariosAct.setInt(1, tarea.getId());
		        ResultSet rs = psUsuariosAct.executeQuery();
		        List<Integer> usuariosActualesBD = new ArrayList<>();

		        while (rs.next()) {
		            usuariosActualesBD.add(rs.getInt(1));
		        }

		       
		        PreparedStatement psInsert = con.prepareStatement(sqlInsertUsuario);
		        for (Integer u : usuariosSeleccionados) {
		            if (!usuariosActualesBD.contains(u)) {
		                
		            	
		            	
		            		psInsert.setInt(1, tarea.getId());
		                psInsert.setInt(2, u);
		                psInsert.executeUpdate();
		            }
		        }
		       
		        PreparedStatement psDelete = con.prepareStatement(sqlDeleteUsuario);
		        for (Integer u : usuariosActualesBD) {
		            if (!usuariosSeleccionados.contains(u)) {
		                psDelete.setInt(1, tarea.getId());
		                psDelete.setInt(2, u);
		                psDelete.executeUpdate();
		            }
		        }

		    } catch (SQLException e) {
		        throw new DAOException("Error actualizando tarea", e);
		    }
		}

	 public List<Usuario> getUsuariosAsignados(int idTarea) throws DAOException {
		    List<Usuario> usuarios = new ArrayList<>();

		    String sql = "SELECT u.id, u.usuario, u.mail FROM usuario u  INNER JOIN tarea_usuario tu ON tu.idEmpleado = u.id WHERE tu.idTarea = ?"; 
		                 
		                  
		                 

		    try (Connection con = ConexionDB.getConexion();
		         PreparedStatement ps = con.prepareStatement(sql)) {

		        ps.setInt(1, idTarea);

		        try (ResultSet rs = ps.executeQuery()) {

		            while (rs.next()) {
		                Usuario u = new Usuario();
		                u.setId(rs.getInt("id"));
		                u.setNombre(rs.getString("usuario"));
		                u.setMail(rs.getString("mail"));

		                usuarios.add(u);
		            }
		        }
		    } catch (SQLException e) {
		        throw new DAOException("Error obteniendo usuarios asignados a la tarea", e);
		    }

		    return usuarios;
		}

		public void delete(int id) throws DAOException {
			String sql = "DELETE FROM tarea WHERE id = ?";
			String sql2="DELETE FROM tarea_usuario where idTarea=?";
			try (Connection con = ConexionDB.getConexion()){
					PreparedStatement ps2=con.prepareStatement(sql2);
		            ps2.setInt(1, id);
		            ps2.executeUpdate();
					PreparedStatement ps = con.prepareStatement(sql);
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
		                //CategoriaTareaDAO cdao = new CategoriaTareaDAO();
		                //CategoriaTarea cat = cdao.getById(rs.getInt("idCategoria"));
		                tarea.setIdCategoria(rs.getInt("idCategoria"));
		                
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
	                //CategoriaTareaDAO cdao = new CategoriaTareaDAO();
	                //CategoriaTarea cat = cdao.getById(rs.getInt("idCategoria"));
	                tarea.setIdCategoria(rs.getInt("idCategoria"));
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

		            // Cargar CategoriaTarea 
		            //CategoriaTareaDAO cdao = new CategoriaTareaDAO();
		            //CategoriaTarea cat = cdao.getById());
		            tarea.setIdCategoria(rs.getInt("idCategoria"));

		            tareas.add(tarea);
		        }
		    } catch (SQLException e) {
		        throw new DAOException("Error al obtener tareas para etapa id: " + idEtapa, e);
		    }
		    return tareas;
		}
		
		public List<Tarea> getByUsuarioId(int idEmpleado) throws DAOException {
		    String sql = "SELECT t.* FROM tarea t INNER JOIN tarea_usuario tu ON t.id = tu.idTarea "
		    		+ " WHERE idEmpleado = ? ORDER BY fechaInicio ASC"; // Orden lógico por fecha
		    List<Tarea> tareas = new ArrayList<>();
		    try (Connection con = ConexionDB.getConexion();
		         PreparedStatement ps = con.prepareStatement(sql)) {
		        ps.setInt(1, idEmpleado);
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

		            // Cargar CategoriaTarea 
		            //CategoriaTareaDAO cdao = new CategoriaTareaDAO();
		            //CategoriaTarea cat = cdao.getById());
		            tarea.setIdCategoria(rs.getInt("idCategoria"));

		            tareas.add(tarea);
		        }
		    } catch (SQLException e) {
		        throw new DAOException("Error al obtener tareas para el usuario id: " + idEmpleado, e);
		    }
		    return tareas;
		}

}
