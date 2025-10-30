package proyectos;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.LinkedList;
import java.util.List;

import clientes.Cliente;
import clientes.ClienteDAO;
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
                
                // Cargar supervisor mediante el DAO
                UsuariosDAO usuarioDAO = new UsuariosDAO();
                Usuario sup = usuarioDAO.getOne(rs.getInt("idSupervisor"));
                pro.setSupervisor(sup);
                
                // Cargar usuarios relacionados (si es necesario)
                pro.setUsuarios(new LinkedList<>());
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
                lista.add(pro);
            }
        } catch (SQLException e) {
        	throw new DAOException("Error al obtener todos los proyectos", e);
        }
        return lista;
    }
}