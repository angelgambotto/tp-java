package categoriaTarea;

import utils.ConexionDB;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

import exceptions.DAOException;

public class CategoriaTareaDAO {

    public void insert(CategoriaTarea cat) throws DAOException {
        String sql = "INSERT INTO categoriatarea (nombre, descripcion) VALUES (?, ?)";

        try (Connection con = ConexionDB.getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, cat.getNombre());
            ps.setString(2, cat.getDescripcion());
            ps.executeUpdate();

        } catch (SQLException e) {
        	throw new DAOException("Error al insertar categoría"+ cat.getNombre(), e);
        }
    }

    public void update(CategoriaTarea cat) throws DAOException {
        String sql = "UPDATE categoriatarea SET nombre = ?, descripcion = ? WHERE id = ?";

        try (Connection con = ConexionDB.getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, cat.getNombre());
            ps.setString(2, cat.getDescripcion());
            ps.setInt(3, cat.getId());
            ps.executeUpdate();

        } catch (SQLException e) {
        	throw new DAOException("Error al actualizar categoría"+ cat.getNombre(), e);
        }
    }

    public void delete(int id) throws DAOException {
        String sql = "DELETE FROM categoriatarea WHERE id = ?";

        try (Connection con = ConexionDB.getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, id);
            ps.executeUpdate();

        } catch (SQLException e) {
        	throw new DAOException("Error al eliminar la categoría con id: "+ id, e);
        }
    }

    public CategoriaTarea getById(int id) throws DAOException {
        String sql = "SELECT * FROM categoriatarea WHERE id = ?";
        CategoriaTarea cat = null;

        try (Connection con = ConexionDB.getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                cat = new CategoriaTarea();
                cat.setId(rs.getInt("id"));
                cat.setNombre(rs.getString("nombre"));
                cat.setDescripcion(rs.getString("descripcion"));
            }

        } catch (SQLException e) {
            throw new DAOException("Error al recuperar la categoria con id: " + id, e);
        }

        return cat;
    }

    public List<CategoriaTarea> getAll() throws DAOException {
        String sql = "SELECT * FROM categoriatarea";
        List<CategoriaTarea> lista = new ArrayList<>();

        try (Connection con = ConexionDB.getConexion();
             Statement st = con.createStatement();
             ResultSet rs = st.executeQuery(sql)) {

            while (rs.next()) {
                CategoriaTarea cat = new CategoriaTarea();
                cat.setId(rs.getInt("id"));
                cat.setNombre(rs.getString("nombre"));
                cat.setDescripcion(rs.getString("descripcion"));
                lista.add(cat);
            }

        } catch (SQLException e) {
        	throw new DAOException("Error al obtener todas las categorias", e);
        }

        return lista;
    }
}