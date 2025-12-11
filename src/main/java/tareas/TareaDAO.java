package tareas;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.time.LocalDate;
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

	public Integer insert(Tarea tarea) throws DAOException {
	    String sql = "INSERT INTO tarea (nombre, descripcion, estado, fechaInicio, fechaFin, idEtapa, idCategoria) VALUES (?,?,?,?,?,?,?)";
	    
	    
	    Connection con = null;
	    PreparedStatement ps = null;
	    
	    ResultSet rs = null;
	    Integer id=null;
	    try {
	        con = ConexionDB.getConexion();
	        con.setAutoCommit(false);
	        
	        ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
	        ps.setString(1, tarea.getNombre());
	        ps.setString(2, tarea.getDescripcion());
	        ps.setString(3, tarea.getEstado());
	        ps.setDate(4, new Date(tarea.getFechaInicio().getTime()));
	        if (tarea.getFechaFin() != null) {
	            ps.setDate(5, new Date(tarea.getFechaFin().getTime()));
	        } else {
	            ps.setNull(5, java.sql.Types.DATE);
	        }
	        ps.setInt(6, tarea.getIdEtapa());
	        ps.setInt(7, tarea.getIdCategoria());
	        ps.executeUpdate();
	        
	       
	        rs = ps.getGeneratedKeys();
	        if (rs.next()) {
	            System.out.println("El id de la tarea es: " + rs.getInt(1));
	            id=rs.getInt(1);
	            tarea.setId(id);
	        }
	        
	 
	       
	        
	        
	        con.commit();
	       
	        System.out.println("transacción completada ");
	        return id;
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
	            
	            if (con != null) {
	                con.setAutoCommit(true);
	                con.close();
	            }
	        } catch (SQLException e) {
	            e.printStackTrace();
	        }
	    }
	}
	 
	 public void update(Tarea tarea) throws DAOException {

		    String sqlUpdate = "UPDATE tarea SET nombre=?, descripcion=?, fechaInicio=?, fechaFin=?, idCategoria=?,estado=? WHERE id=?";
		    

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
		        

		    } catch (SQLException e) {
		        throw new DAOException("Error actualizando tarea", e);
		    }
		}

	 public List<Usuario> getUsuariosAsignados(int idTarea) throws DAOException {
		    List<Usuario> usuarios = new ArrayList<>();

		    String sql = "SELECT u.id, u.nombre, u.apellido, u.mail FROM usuario u  INNER JOIN tarea_usuario tu ON tu.idEmpleado = u.id WHERE tu.idTarea = ?"; 
		                 
		                  
		                 

		    try (Connection con = ConexionDB.getConexion();
		         PreparedStatement ps = con.prepareStatement(sql)) {

		        ps.setInt(1, idTarea);

		        try (ResultSet rs = ps.executeQuery()) {

		            while (rs.next()) {
		                Usuario u = new Usuario();
		                u.setId(rs.getInt("id"));
		                u.setNombre(rs.getString("nombre"));
		                u.setApellido(rs.getString("apellido"));
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
			String sqlHoras = "DELETE FROM hora_trabajada WHERE idTarea = ?";
			String sqlComentario = "DELETE FROM comentario WHERE idTarea = ?";
			String sqlTareaUsuario = "DELETE FROM tarea_usuario WHERE idTarea = ?";
			String sqlTarea = "DELETE FROM tarea WHERE id = ?";

		    try (Connection con = ConexionDB.getConexion()) {
		    	
		    	try (PreparedStatement ps2 = con.prepareStatement(sqlHoras)) {
		    		ps2.setInt(1, id);
		    		ps2.executeUpdate();
		    	}
		    	try (PreparedStatement ps3 = con.prepareStatement(sqlComentario)) {
		    		ps3.setInt(1, id);
		    		ps3.executeUpdate();
		    	}

		        try (PreparedStatement ps1 = con.prepareStatement(sqlTareaUsuario)) {
		            ps1.setInt(1, id);
		            ps1.executeUpdate();
		        }


		        // Finalmente borrar la tarea
		        try (PreparedStatement ps4 = con.prepareStatement(sqlTarea)) {
		            ps4.setInt(1, id);
		            ps4.executeUpdate();
		        }
		            

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
	        	throw new DAOException("Error al obtener la tarea con id: "+ id, e);
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
		public boolean tieneTareasIncompletas  (int idEtapa) throws DAOException {
			String sql="SELECT COUNT(*) from tarea where idEtapa=? and estado<>'Done'";
			try {
				Connection con=ConexionDB.getConexion();
				PreparedStatement ps=con.prepareStatement(sql);
				ps.setInt(1, idEtapa);
				ResultSet rs=ps.executeQuery();
				if(rs.next()) {
					return rs.getInt(1)>0;
				}
				
			}catch (SQLException e) {
				throw new DAOException("Error al obtener tareas incompletas de etapa con id: "+idEtapa,e);
			}
	return false;
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

		public void asignarEmpleados(int idT, List<Integer> asignados) throws DAOException {
	    	String sqlActuales = "SELECT * from tarea_usuario where idTarea = ?";
	    	String sqlAsignar = "INSERT INTO tarea_usuario (idTarea, idEmpleado) VALUES (?,?)";
	    	String sqlBaja = "DELETE FROM tarea_usuario where idEmpleado = ? and idTarea = ?";
	    	
	    	try {
	    		Connection con=ConexionDB.getConexion();
	    		PreparedStatement psUsuariosAct = con.prepareStatement(sqlActuales);
		    	psUsuariosAct.setInt(1, idT);
		        ResultSet rs = psUsuariosAct.executeQuery();
		        List<Integer> usuariosActualesBD = new ArrayList<>();

		        while (rs.next()) {
		            usuariosActualesBD.add(rs.getInt("idEmpleado"));
		        }
		        
		        PreparedStatement psInsert = con.prepareStatement(sqlAsignar);
		        for (Integer u : asignados) {
		            if (!usuariosActualesBD.contains(u)) {
		                psInsert.setInt(1, idT);
		                psInsert.setInt(2, u);
		                psInsert.executeUpdate();
		            }
		        }
		       
		        PreparedStatement psDelete = con.prepareStatement(sqlBaja);
		        for (Integer u : usuariosActualesBD) {
		            if (!asignados.contains(u)) {
		            	psDelete.setInt(1, u);
		            	psDelete.setInt(2, idT);
		                psDelete.executeUpdate();
		            }
		        }

	    	} catch (SQLException e) {
		        throw new DAOException("Error actualizando proyecto", e);
		    }
	    }
}
