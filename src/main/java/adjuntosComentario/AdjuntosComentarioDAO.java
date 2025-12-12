package adjuntosComentario;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

import utils.ConexionDB;

public class AdjuntosComentarioDAO {

	    public static void insertar(AdjuntosComentario a) {
	        String sql = "INSERT INTO adjuntos_comentario (id_comentario, nombre_original, nombre_guardado, ruta, tamano_kb, tipo_mime) VALUES (?,?,?,?,?,?)";
	        try (Connection con = ConexionDB.getConexion();
	             PreparedStatement ps = con.prepareStatement(sql)) {
	            ps.setInt(1, a.getIdComentario());
	            ps.setString(2, a.getNombreOriginal());
	            ps.setString(3, a.getNombreGuardado());
	            ps.setString(4, a.getRuta());
	            ps.setInt(5, a.getTamanoKb());
	            ps.setString(6, a.getTipoMime());
	            ps.executeUpdate();
	        } catch (SQLException e) {
	            e.printStackTrace();
	        }
	    }

	    public static List<AdjuntosComentario> obtenerPorComentario(int idComentario) {
	        List<AdjuntosComentario> lista = new ArrayList<>();
	        String sql = "SELECT * FROM adjuntos_comentario WHERE id_comentario = ?";
	        try (Connection con = ConexionDB.getConexion();
	             PreparedStatement ps = con.prepareStatement(sql)) {
	            ps.setInt(1, idComentario);
	            ResultSet rs = ps.executeQuery();
	            while (rs.next()) {
	                AdjuntosComentario a = new AdjuntosComentario();
	                a.setId(rs.getInt("id"));
	                a.setIdComentario(rs.getInt("id_comentario"));
	                a.setNombreOriginal(rs.getString("nombre_original"));
	                a.setNombreGuardado(rs.getString("nombre_guardado"));
	                a.setRuta(rs.getString("ruta"));
	                a.setTamanoKb(rs.getInt("tamano_kb"));
	                a.setTipoMime(rs.getString("tipo_mime"));
	                lista.add(a);
	            }
	        } catch (SQLException e) {
	            e.printStackTrace();
	        }
	        return lista;
	    }
	}

