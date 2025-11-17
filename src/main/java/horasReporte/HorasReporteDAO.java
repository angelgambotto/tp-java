package horasReporte;

import java.sql.Connection;
import java.util.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import exceptions.DAOException;
import utils.ConexionDB;


public class HorasReporteDAO {

    public List<HorasReporte> horasPorUsuario(Date desde, Date hasta) throws DAOException {
        String sql = """
            SELECT u.id, u.nombre, u.apellido, SUM(h.cantidad) AS horas
            FROM hora_trabajada h
            JOIN usuario u ON u.id = h.idEmpleado
            WHERE (? IS NULL OR h.fecha >= ?)
              AND (? IS NULL OR h.fecha <= ?)
            GROUP BY u.id, u.nombre, u.apellido
        """;

        List<HorasReporte> lista = new ArrayList<>();

        try (Connection con = ConexionDB.getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setDate(1, desde != null ? new java.sql.Date(desde.getTime()) : null);
            ps.setDate(2, desde != null ? new java.sql.Date(desde.getTime()) : null);
            ps.setDate(3, hasta != null ? new java.sql.Date(hasta.getTime()) : null);
            ps.setDate(4, hasta != null ? new java.sql.Date(hasta.getTime()) : null);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
            	HorasReporte dto = new HorasReporte();
                dto.setIdUsuario(rs.getInt("id"));
                dto.setNombreUsuario(rs.getString("nombre"));
                dto.setApellidoUsuario(rs.getString("apellido"));
                dto.setHoras(rs.getInt("horas"));
                lista.add(dto);
            }

        } catch (SQLException e) {
        	System.out.println("error en el dao: "+e);
            throw new DAOException("Error generando reporte horasPorUsuario", e);
            
        }

        return lista;
    }


    // === HORAS POR USUARIO - PROYECTO ===
    public List<HorasReporte> horasPorUsuarioProyecto(Date desde, Date hasta) throws DAOException {
        String sql = """
            SELECT u.id AS idUsuario, u.nombre, u.apellido,
                   p.id AS idProyecto, p.nombre AS proyecto,
                   SUM(h.cantidad) AS horas
            FROM hora_trabajada h
            JOIN usuario u ON u.id = h.idEmpleado
            JOIN tarea t ON t.id = h.idTarea
            JOIN etapa e ON e.id = t.idEtapa
            JOIN proyecto p ON p.id = e.idProyecto
            WHERE (? IS NULL OR h.fecha >= ?)
              AND (? IS NULL OR h.fecha <= ?)
            GROUP BY u.id, p.id
            ORDER BY u.nombre, p.nombre;
        """;

        List<HorasReporte> lista = new ArrayList<>();

        try (Connection con = ConexionDB.getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setDate(1, desde != null ? new java.sql.Date(desde.getTime()) : null);
            ps.setDate(2, desde != null ? new java.sql.Date(desde.getTime()) : null);
            ps.setDate(3, hasta != null ? new java.sql.Date(hasta.getTime()) : null);
            ps.setDate(4, hasta != null ? new java.sql.Date(hasta.getTime()) : null);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
            	HorasReporte dto = new HorasReporte();
                dto.setIdUsuario(rs.getInt("idUsuario"));
                dto.setNombreUsuario(rs.getString("nombre"));
                dto.setApellidoUsuario(rs.getString("apellido"));
                dto.setIdProyecto(rs.getInt("idProyecto"));
                dto.setNombreProyecto(rs.getString("proyecto"));
                dto.setHoras(rs.getInt("horas"));
                lista.add(dto);
            }

        } catch (SQLException e) {
            throw new DAOException("Error generando horasPorUsuarioProyecto", e);
        }

        return lista;
    }


    // === HORAS POR USUARIO - PROYECTO - ETAPA ===
    public List<HorasReporte> horasPorUsuarioProyectoEtapa(Date desde, Date hasta) throws DAOException {
        String sql = """
            SELECT u.id AS idUsuario, u.nombre, u.apellido,
                   p.id AS idProyecto, p.nombre AS proyecto,
                   e.id AS idEtapa, e.nombre AS etapa,
                   SUM(h.cantidad) AS horas
            FROM hora_trabajada h
            JOIN usuario u ON u.id = h.idEmpleado
            JOIN tarea t ON t.id = h.idTarea
            JOIN etapa e ON e.id = t.idEtapa
            JOIN proyecto p ON p.id = e.idProyecto
            WHERE (? IS NULL OR h.fecha >= ?)
              AND (? IS NULL OR h.fecha <= ?)
            GROUP BY u.id, p.id, e.id
            ORDER BY usuario, proyecto, etapa;
        """;

        List<HorasReporte> lista = new ArrayList<>();

        try (Connection con = ConexionDB.getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setDate(1, desde != null ? new java.sql.Date(desde.getTime()) : null);
            ps.setDate(2, desde != null ? new java.sql.Date(desde.getTime()) : null);
            ps.setDate(3, hasta != null ? new java.sql.Date(hasta.getTime()) : null);
            ps.setDate(4, hasta != null ? new java.sql.Date(hasta.getTime()) : null);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
            	HorasReporte dto = new HorasReporte();
                dto.setIdUsuario(rs.getInt("idUsuario"));
                dto.setNombreUsuario(rs.getString("nombre"));
                dto.setApellidoUsuario(rs.getString("apellido"));
                dto.setIdProyecto(rs.getInt("idProyecto"));
                dto.setNombreProyecto(rs.getString("proyecto"));
                dto.setIdEtapa(rs.getInt("idEtapa"));
                dto.setNombreEtapa(rs.getString("etapa"));
                dto.setHoras(rs.getInt("horas"));
                lista.add(dto);
            }

        } catch (SQLException e) {
            throw new DAOException("Error generando horasPorUsuarioProyectoEtapa", e);
        }

        return lista;
    }


    // === HORAS POR USUARIO - PROYECTO - ETAPA - TAREA ===
    public List<HorasReporte> horasPorUsuarioProyectoEtapaTarea(Date desde, Date hasta) throws DAOException {
        String sql = """
            SELECT u.id AS idUsuario, u.nombre, u.apellido,
                   p.id AS idProyecto, p.nombre AS proyecto,
                   e.id AS idEtapa, e.nombre AS etapa,
                   t.id AS idTarea, t.nombre AS tarea,
                   SUM(h.cantidad) AS horas
            FROM hora_trabajada h
            JOIN usuario u ON u.id = h.idEmpleado
            JOIN tarea t ON t.id = h.idTarea
            JOIN etapa e ON e.id = t.idEtapa
            JOIN proyecto p ON p.id = e.idProyecto
            WHERE (? IS NULL OR h.fecha >= ?)
              AND (? IS NULL OR h.fecha <= ?)
            GROUP BY u.id, p.id, e.id, t.id
            ORDER BY usuario, proyecto, etapa, tarea;
        """;

        List<HorasReporte> lista = new ArrayList<>();

        try (Connection con = ConexionDB.getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setDate(1, desde != null ? new java.sql.Date(desde.getTime()) : null);
            ps.setDate(2, desde != null ? new java.sql.Date(desde.getTime()) : null);
            ps.setDate(3, hasta != null ? new java.sql.Date(hasta.getTime()) : null);
            ps.setDate(4, hasta != null ? new java.sql.Date(hasta.getTime()) : null);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
            	HorasReporte dto = new HorasReporte();
                dto.setIdUsuario(rs.getInt("idUsuario"));
                dto.setNombreUsuario(rs.getString("nombre"));
                dto.setApellidoUsuario(rs.getString("apellido"));
                dto.setIdProyecto(rs.getInt("idProyecto"));
                dto.setNombreProyecto(rs.getString("proyecto"));
                dto.setIdEtapa(rs.getInt("idEtapa"));
                dto.setNombreEtapa(rs.getString("etapa"));
                dto.setIdTarea(rs.getInt("idTarea"));
                dto.setNombreTarea(rs.getString("tarea"));
                dto.setHoras(rs.getInt("horas"));
                lista.add(dto);
            }

        } catch (SQLException e) {
            throw new DAOException("Error generando horasPorUsuarioProyectoEtapaTarea", e);
        }

        return lista;
    }
}
