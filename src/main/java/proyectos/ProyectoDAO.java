package proyectos;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.LinkedList;
import java.util.List;

import clientes.Cliente;
import clientes.ClienteDAO;
import etapas.EtapaDAO;
import exceptions.DAOException;
import utils.ConexionDB;
import java.sql.Date;
import usuarios.Usuario;
import usuarios.UsuariosDAO;

public class ProyectoDAO {
    public void insert(Proyecto pro) throws DAOException {
        String sql = "INSERT INTO Proyecto (nombre, descripcion, estado, idCliente, fechaCreacion, idSupervisor) VALUES (?,?,?,?,?,?)";
        try (Connection con = ConexionDB.getConexion();
             PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
        	System.out.println(pro.getSupervisor().getId());
            ps.setString(1, pro.getNombre());
            ps.setString(2, pro.getDescripcion());
            ps.setString(3, pro.getEstado());
            ps.setInt(4, pro.getCliente().getId());
            ps.setDate(5, new Date(pro.getFechaCreacion().getTime()));
            ps.setInt(6, pro.getSupervisor().getId());
            ps.executeUpdate();
            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) {
                    pro.setId(rs.getInt(1));
                }
            }
        } catch (SQLException e) {
            throw new DAOException("Error al agregar el proyecto: " + pro.getNombre(), e);
        }
    }
    public void update(Proyecto pro) throws DAOException {
        String sql = "UPDATE Proyecto SET nombre = ?, descripcion = ?, estado = ?, idCliente = ?, fechaCreacion = ?, idSupervisor = ? WHERE id = ?";
        try (Connection con = ConexionDB.getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, pro.getNombre());
            ps.setString(2, pro.getDescripcion());
            ps.setString(3, pro.getEstado());
            ps.setInt(4, pro.getCliente().getId());
            ps.setDate(5, new Date(pro.getFechaCreacion().getTime()));
            ps.setInt(6, pro.getSupervisor().getId());
            ps.setInt(7, pro.getId());
            ps.executeUpdate();
        } catch (SQLException e) {
        	throw new DAOException("Error al actualizar el proyecto: " + pro.getNombre(), e);
        }
    }
    public void delete(int id) throws DAOException {
        String sql = "DELETE FROM Proyecto WHERE id = ?";
        try (Connection con = ConexionDB.getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.executeUpdate();
        } catch (SQLException e) {
        	throw new DAOException("Error al eliminar el proyecto con id: " + id, e);
        }
    }
    public Proyecto getById(int id) throws DAOException {
        String sql = "SELECT * FROM Proyecto WHERE id = ?";
        Proyecto pro = null;
        try (Connection con = ConexionDB.getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                pro = new Proyecto();
                pro.setId(rs.getInt("id"));
                pro.setNombre(rs.getString("nombre"));
                pro.setDescripcion(rs.getString("descripcion"));
                pro.setEstado(rs.getString("estado"));
                pro.setFechaCreacion(rs.getDate("fechaCreacion"));

                ClienteDAO clienteDAO = new ClienteDAO();
                Cliente cli = clienteDAO.getOne(rs.getInt("idCliente"));
                pro.setCliente(cli);

                UsuariosDAO usuarioDAO = new UsuariosDAO();
                Usuario sup = usuarioDAO.getOne(rs.getInt("idSupervisor"));
                pro.setSupervisor(sup);

                pro.setUsuarios(new LinkedList<>()); // Si lo cargas lazy, aquí vacío

                EtapaDAO etapaDAO = new EtapaDAO();
                pro.setEtapas(etapaDAO.getByProyectoIdConTareas(id));
            }
        } catch (SQLException e) {
            throw new DAOException("Error al obtener el proyecto con id: " + id, e);
        }
        return pro;
    }
    
    public List<Proyecto> getAll() throws DAOException {
        String sql = "SELECT * FROM Proyecto";
        List<Proyecto> lista = new ArrayList<>();
        try (Connection con = ConexionDB.getConexion();
             Statement st = con.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            while (rs.next()) {
                Proyecto pro = new Proyecto();
                pro.setId(rs.getInt("id"));
                pro.setNombre(rs.getString("nombre"));
                pro.setDescripcion(rs.getString("descripcion"));
                pro.setEstado(rs.getString("estado"));
                pro.setFechaCreacion(rs.getDate("fechaCreacion"));
                
                ClienteDAO clienteDAO = new ClienteDAO();
                Cliente cli = clienteDAO.getOne(rs.getInt("idCliente"));
                pro.setCliente(cli);
                // Cargar supervisor mediante el DAO
                UsuariosDAO usuarioDAO = new UsuariosDAO();
                Usuario sup = usuarioDAO.getOne(rs.getInt("idSupervisor"));
                pro.setSupervisor(sup);
                
                // Cargar usuarios relacionados (si es necesario)
                pro.setUsuarios(new LinkedList<>());
                pro.setEtapas(new LinkedList<>());
                lista.add(pro);
            }
        } catch (SQLException e) {
        	throw new DAOException("Error al obtener todos los proyectos", e);
        }
        return lista;
    }
    
    public void asignarEmpleados(int idPro, List<Integer> asignados) throws DAOException {
    	String sqlActuales = "SELECT * from proyecto_usuario where idProyecto = ?";
    	String sqlAsignar = "INSERT INTO proyecto_usuario (idProyecto, idEmpleado, fechaAlta) VALUES (?,?,?)";
    	String sqlBaja = "UPDATE proyecto_usuario SET fechaBaja = ? where idEmpleado = ? and idProyecto = ? and fechaBaja is null";
    	
    	try {
    		Connection con=ConexionDB.getConexion();
    		con.setAutoCommit(false);
    		PreparedStatement psUsuariosAct = con.prepareStatement(sqlActuales);
	    	psUsuariosAct.setInt(1, idPro);
	        ResultSet rs = psUsuariosAct.executeQuery();
	        List<Integer> usuariosActualesBD = new ArrayList<>();

	        while (rs.next()) {
	            usuariosActualesBD.add(rs.getInt("idEmpleado"));
	        }
	        rs.close();
	        psUsuariosAct.close();
	        PreparedStatement psInsert = con.prepareStatement(sqlAsignar);
	        for (Integer u : asignados) {
	            if (!usuariosActualesBD.contains(u)) {
	                psInsert.setInt(1, idPro);
	                psInsert.setInt(2, u);
	                psInsert.setDate(3, Date.valueOf(LocalDate.now()));
	                psInsert.executeUpdate();
	            }
	        }
	        psInsert.close();
	        PreparedStatement psDelete = con.prepareStatement(sqlBaja);
	        for (Integer u : usuariosActualesBD) {
	            if (!asignados.contains(u)) {
	            	psDelete.setDate(1, Date.valueOf(LocalDate.now()));
	            	psDelete.setInt(2, u);
	            	psDelete.setInt(3, idPro);
	                psDelete.executeUpdate();
	            }
	        }
	        psDelete.close();
	        con.commit();
    	} catch (SQLException e) {
    		
	        throw new DAOException("Error actualizando proyecto", e);
	    }
    }
    
	 public List<Usuario> getUsuariosAsignados(int idProyecto) throws DAOException {
		    List<Usuario> usuarios = new ArrayList<>();

		    String sql = "SELECT u.id, u.nombre, u.apellido, u.mail FROM usuario u  INNER JOIN proyecto_usuario pu ON pu.idEmpleado = u.id WHERE pu.idProyecto = ? and pu.fechaBaja is null";    

		    try (Connection con = ConexionDB.getConexion();
		         PreparedStatement ps = con.prepareStatement(sql)) {
		        ps.setInt(1, idProyecto);

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
		        throw new DAOException("Error obteniendo usuarios asignados al proyecto", e);
		    }

		    return usuarios;
		}
	 
    public List<Proyecto> getByIdEmpleado(int idEmpleado) throws DAOException {
        String sql = """
        				SELECT p.* 
        				FROM proyecto_usuario pu
        				inner join proyecto p
        		 			on pu.idProyecto = p.id 
        				WHERE pu.IdEmpleado = ?
        				""";
        List<Proyecto> lista = new ArrayList<>();
        try (Connection con = ConexionDB.getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, idEmpleado);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
            	Proyecto pro = new Proyecto();
                pro = new Proyecto();
                pro.setId(rs.getInt("id"));
                pro.setNombre(rs.getString("nombre"));
                pro.setDescripcion(rs.getString("descripcion"));
                pro.setEstado(rs.getString("estado"));
                pro.setFechaCreacion(rs.getDate("fechaCreacion"));

                ClienteDAO clienteDAO = new ClienteDAO();
                Cliente cli = clienteDAO.getOne(rs.getInt("idCliente"));
                pro.setCliente(cli);

                UsuariosDAO usuarioDAO = new UsuariosDAO();
                Usuario sup = usuarioDAO.getOne(rs.getInt("idSupervisor"));
                pro.setSupervisor(sup);

                pro.setUsuarios(new LinkedList<>()); // Si lo cargas lazy, aquí vacío

                /*	EtapaDAO etapaDAO = new EtapaDAO();
	                pro.setEtapas(etapaDAO.getByProyectoIdConTareas(id));*/
                lista.add(pro);
            }
        } catch (SQLException e) {
            throw new DAOException("Error al obtener los proyectos del empleado: " + idEmpleado, e);
        }
        return lista;
    }
    
    public List<Proyecto> getByIdCliente(int idCliente) throws DAOException {
        String sql = """
        				SELECT p.* 
        				FROM proyecto p
        				WHERE p.idCliente = ?
        				""";
        List<Proyecto> lista = new ArrayList<>();
        try (Connection con = ConexionDB.getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, idCliente);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
            	Proyecto pro = new Proyecto();
                pro = new Proyecto();
                
                int id = rs.getInt("id");
                pro.setId(id);
                pro.setNombre(rs.getString("nombre"));
                pro.setDescripcion(rs.getString("descripcion"));
                pro.setEstado(rs.getString("estado"));
                pro.setFechaCreacion(rs.getDate("fechaCreacion"));

                UsuariosDAO usuarioDAO = new UsuariosDAO();
                Usuario sup = usuarioDAO.getOne(rs.getInt("idSupervisor"));
                pro.setSupervisor(sup);

                pro.setUsuarios(new LinkedList<>()); // Si lo cargas lazy, aquí vacío

                EtapaDAO etapaDAO = new EtapaDAO();
                pro.setEtapas(etapaDAO.getByProyectoIdConTareas(id));
                lista.add(pro);
            }
        } catch (SQLException e) {
            throw new DAOException("Error al obtener los proyectos del empleado: " + idCliente, e);
        }
        return lista;
    }

}






