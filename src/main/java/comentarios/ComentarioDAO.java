package comentarios;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;
import exceptions.DAOException;
import utils.ConexionDB;

public class ComentarioDAO {
	public int insert(Comentario com) throws DAOException {
        String sql = "INSERT INTO comentario (idTarea, idAutor, fecha, texto) VALUES (?, ?, ?, ?)";

        try (Connection con = ConexionDB.getConexion();
             PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setInt(1, com.getIdTarea());
            ps.setInt(2, com.getIdEmpleado());
            ps.setTimestamp(3, new java.sql.Timestamp(com.getFecha().getTime()));
            ps.setString(4, com.getTexto());
            ps.executeUpdate();
            
            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }

        } catch (SQLException e) {
        	throw new DAOException("Error al insertar comentario en la tarea: "+ com.getIdTarea(), e);
        }
        return -1;
    }
	
	public void update(Comentario com) throws DAOException {
        String sql = "UPDATE comentario SET fecha = ?, texto = ? WHERE id = ?";
        try (Connection con = ConexionDB.getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {
        	ps.setInt(3, com.getId());
            ps.setTimestamp(1, new java.sql.Timestamp(com.getFecha().getTime()));
            ps.setString(2, com.getTexto());
            ps.executeUpdate();
        } catch (SQLException e) {
        	throw new DAOException("Error al actualizar comentario: "+ com.getId(), e);
        }
    }
	
	public void delete(int id) throws DAOException {
        String sql = "DELETE FROM comentario WHERE id = ?";
        try (Connection con = ConexionDB.getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {
        	ps.setInt(1, id);
            ps.executeUpdate();
        } catch (SQLException e) {
        	throw new DAOException("Error al eliminar el comentario con id: " + id, e);
        }
    }
	
	public Comentario getById(int id) throws DAOException {
        String sql = "SELECT * FROM comentario WHERE id = ?";
        Comentario com = null;

        try (Connection con = ConexionDB.getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
            	 com = new Comentario();
            	 com.setId(rs.getInt("id"));
                 com.setIdTarea(rs.getInt("idTarea"));
                 com.setIdEmpleado(rs.getInt("idAutor"));
                 com.setFecha(rs.getTimestamp("fecha"));                 
                 com.setTexto(rs.getString("texto"));
            }

        } catch (SQLException e) {
            throw new DAOException("Error al recuperar el comentario con id: " + id, e);
        }

        return com;
    }
	
	public List<Comentario> getAllByIdTarea(int idTarea) throws DAOException {
        String sql = "SELECT * FROM comentario WHERE idTarea = ? ORDER BY fecha DESC";
        List<Comentario> lista = new ArrayList<>();

        try (Connection con = ConexionDB.getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, idTarea);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
            	Comentario com = new Comentario();
            	com.setId(rs.getInt("id"));
                com.setIdTarea(rs.getInt("idTarea"));
                com.setIdEmpleado(rs.getInt("idAutor"));
                Timestamp timestamp = rs.getTimestamp("fecha");
                if (timestamp != null) {
                    com.setFecha(new Date(timestamp.getTime()));
                }
                com.setTexto(rs.getString("texto"));
                lista.add(com);
            }

        } catch (SQLException e) {
            throw new DAOException("Error al recuperar los comentarios con idTarea: " + idTarea, e);
        }

        return lista;
    }
	
    public List<Comentario> getAll() throws DAOException {
        String sql = "SELECT * FROM comentario";
        List<Comentario> lista = new ArrayList<>();

        try (Connection con = ConexionDB.getConexion();
             Statement st = con.createStatement();
             ResultSet rs = st.executeQuery(sql)) {

            while (rs.next()) {
            	Comentario com = new Comentario();
            	com.setId(rs.getInt("id"));
                com.setIdTarea(rs.getInt("idTarea"));
                com.setIdEmpleado(rs.getInt("idAutor"));
                Timestamp timestamp = rs.getTimestamp("fecha");
                if (timestamp != null) {
                    com.setFecha(new Date(timestamp.getTime()));
                }
                com.setTexto(rs.getString("texto"));
                lista.add(com);
            }

        } catch (SQLException e) {
        	throw new DAOException("Error al obtener todas las horas trabajadas", e);
        }

        return lista;
    }

	
}
