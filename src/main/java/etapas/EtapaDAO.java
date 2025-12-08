package etapas;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.LinkedList;
import java.util.List;
import exceptions.DAOException;
import proyectos.Proyecto;
import proyectos.ProyectoDAO;
import tareas.Tarea;
import tareas.TareaDAO;
import utils.ConexionDB;

public class EtapaDAO {
	
	public int  insert(Etapa etapa) throws DAOException {
		int id=0;
		String sql = "INSERT INTO etapa "
				+ "(nombre, descripcion, estado, fechaInicio, fechaFin, fechaTentativa, idProyecto) VALUES (?, ?, ?, ?, ?, ?, ?)";
		
		try (Connection con = ConexionDB.getConexion();
				
	             PreparedStatement ps = con.prepareStatement(sql,Statement.RETURN_GENERATED_KEYS)) {

	            ps.setString(1, etapa.getNombre());
	            ps.setString(2, etapa.getDescripcion());
	            ps.setString(3, etapa.getEstado());
	         //FECHA INICIO (obligatoria) 
	            ps.setDate(4, etapa.getFechaInicio() != null ? 
	                new java.sql.Date(etapa.getFechaInicio().getTime()) : null);

	            // FECHA FIN (opcional) 
	            ps.setDate(5, etapa.getFechaFin() != null ? 
	                new java.sql.Date(etapa.getFechaFin().getTime()) : null);

	            // FECHA TENTATIVA (opcional) 
	            ps.setDate(6, etapa.getFechaTentativa() != null ? 
	                new java.sql.Date(etapa.getFechaTentativa().getTime()) : null);
	            ps.setInt(7, etapa.getIdProyecto());
	            
	            // para debug
	            int filas = ps.executeUpdate();
	            System.out.println("FILAS INSERTADAS: " + filas);  

	            // Para ver si se insertó de verdad
	            ResultSet rs = ps.getGeneratedKeys();
	            if (rs.next()) {
	                 id=rs.getInt(1);
	            	System.out.println("ID NUEVO: " + id);
	            	// ← ¿Aparece?
	                
	            }
	            return id;

	        } catch (SQLException e) {
	        	throw new DAOException("Error al insertar la etapa: "+ etapa.getNombre(), e);
	        }
	}
	
	public void update(Etapa etapa) throws DAOException{
		 String sql = "UPDATE etapa SET nombre = ?, descripcion = ?, "
		 		+ " estado = ?, fechaInicio = ?, fechaFin = ?, fechaTentativa = ?,"
		 		+ " idProyecto = ? WHERE id = ?";
		 
		 try (Connection con = ConexionDB.getConexion();
	             PreparedStatement ps = con.prepareStatement(sql)) {

	            ps.setString(1, etapa.getNombre());
	            ps.setString(2, etapa.getDescripcion());
	            ps.setString(3, etapa.getEstado());
	            ps.setDate(4, etapa.getFechaInicio() != null ? 
	                    new java.sql.Date(etapa.getFechaInicio().getTime()) : null);

                ps.setDate(5, etapa.getFechaFin() != null ? 
                    new java.sql.Date(etapa.getFechaFin().getTime()) : null);

                ps.setDate(6, etapa.getFechaTentativa() != null ? 
                    new java.sql.Date(etapa.getFechaTentativa().getTime()) : null);
	            ps.setInt(7, etapa.getIdProyecto());
	            ps.setInt(8, etapa.getId());
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
	public boolean tieneEtapasIncompletas(int idProyecto) throws DAOException {
		String sql="SELECT COUNT(*) from etapa where idProyecto=? and estado<>'Done'";
		try {
			Connection con=ConexionDB.getConexion();
			PreparedStatement ps=con.prepareStatement(sql);
			ps.setInt(1, idProyecto);
			ResultSet rs=ps.executeQuery();
			if(rs.next()) {
				return rs.getInt(1)>0;
			}
			
			}
		catch(SQLException e) {
			throw new DAOException("Error al obtener etapas incompletas del proyecto con id: "+idProyecto);
		}
		return false;
	}
	public Etapa getOne(int id) throws DAOException{
		String sql = "SELECT etapa.*, tarea.id as tarea_id FROM etapa LEFT JOIN tarea ON etapa.id = tarea.idEtapa WHERE etapa.id = ?";
		Etapa etapa = null;
		List<Tarea> tareas = new ArrayList<>();
		
		try (Connection con = ConexionDB.getConexion();
	       PreparedStatement ps = con.prepareStatement(sql)) {
			
			ps.setInt(1, id);
	        try (ResultSet rs = ps.executeQuery()) {

	            // ProyectoDAO pdao = new ProyectoDAO();
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
	                    etapa.setIdProyecto(rs.getInt("idProyecto"));

	                    // int idProyecto = rs.getInt("idProyecto");
		                 // if (idProyecto > 0) {
		                 //     etapa.setProyecto(pdao.getById(idProyecto));
	                    // }
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
        	throw new DAOException("Error al cargar la etapa con id: "+ id, e);
        }
		return etapa;

	}
	
	
	//Segun la logica de negocio, nunca vamos a traer todas las etapas en el sistema. Solo las vamos a traer para un proyecto particular (creo) -Angel
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
                etapa.setIdProyecto(rs.getInt("idProyecto"));
                
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
	
	public List<Etapa> getByProyectoId(int idProyecto) throws DAOException {
	    String sql = "SELECT * FROM Etapa WHERE idProyecto = ? ORDER BY fechaInicio ASC"; 
	    List<Etapa> etapas = new ArrayList<>();
	    try (Connection con = ConexionDB.getConexion();
	         PreparedStatement ps = con.prepareStatement(sql)) {
	        ps.setInt(1, idProyecto);
	        ResultSet rs = ps.executeQuery();
	        while (rs.next()) {
	            Etapa etapa = new Etapa();
	            etapa.setId(rs.getInt("id"));
	            etapa.setNombre(rs.getString("nombre"));
	            etapa.setDescripcion(rs.getString("descripcion"));
	            etapa.setEstado(rs.getString("estado"));
	            etapa.setFechaInicio(rs.getDate("fechaInicio"));
	            etapa.setFechaFin(rs.getDate("fechaFin"));
	            etapa.setIdProyecto(idProyecto);
	            etapas.add(etapa);
	        }
	    } catch (SQLException e) {
	        throw new DAOException("Error al obtener etapas para proyecto id: " + idProyecto, e);
	    }
	    return etapas;
	}
	
	public List<Etapa> getByProyectoIdConTareas(int idProyecto) throws DAOException {
	    List<Etapa> etapas = getByProyectoId(idProyecto);
	    TareaDAO tareaDAO = new TareaDAO();
	    for (Etapa etapa : etapas) {
	        List<Tarea> tareas = tareaDAO.getByEtapaId(etapa.getId());
	        etapa.setTareas(new LinkedList<>(tareas));
	        for(Tarea t : tareas) t.setIdEtapa(etapa.getId());
	    }
	    return etapas;
	}
	public String getEstadoByTareaId(int idTarea) throws DAOException {
		String sql="SELECT e.estado FROM etapa e inner join tarea t on t.idEtapa=e.id where t.id=? ";
		try {
			Connection con=ConexionDB.getConexion();
			PreparedStatement ps=con.prepareStatement(sql);
			ps.setInt(1, idTarea);
			ResultSet rs=ps.executeQuery();
			if(rs.next()) {
				return rs.getString("estado");
			}
			return null;
		}
		catch (SQLException e) {
			throw new DAOException("Error obteniendo estado de etapa por tarea con id: "+idTarea,e);
		}
	}
	

}

