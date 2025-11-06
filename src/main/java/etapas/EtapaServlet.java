package etapas;

import java.io.IOException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import exceptions.DAOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import proyectos.Proyecto;
import proyectos.ProyectoDAO;
import usuarios.Usuario;

@WebServlet("/EtapaServlet")
public class EtapaServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private EtapaDAO edao;
    private ProyectoDAO pdao;

    @Override
    public void init() {
        edao = new EtapaDAO();
        pdao = new ProyectoDAO();
    }

    // --- MÉTODOS SEGUROS (NO TOCADOS) ---
    private List<Etapa> cargarEtapasSeguro(HttpServletRequest request) {
        try {
            return edao.getByProyectoId(Integer.parseInt(request.getParameter("idProyecto")));
        } catch (DAOException e) {
            request.setAttribute("error", e.getMessage());
            return new ArrayList<>();
        }
    }

    private Etapa cargarEtaSeguro(HttpServletRequest request, int id) {
        try {
            return edao.getOne(id);
        } catch (DAOException e) {
            request.setAttribute("error", e.getMessage());
            return new Etapa();
        }
    }

    // --- DO GET ---
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {

        Usuario usuario = (Usuario) request.getSession().getAttribute("usuario");
        if (usuario == null || !"Administrador".equalsIgnoreCase(usuario.getRol())) {
            response.sendRedirect("login.jsp");
            return;
        }

        String action = request.getParameter("action");
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");

        // --- OBTENER idProyecto CON VALIDACIÓN ---
        int idProyecto = 0;
        String idProyectoParam = request.getParameter("idProyecto");
        if (idProyectoParam != null && !idProyectoParam.trim().isEmpty()) {
            try {
                idProyecto = Integer.parseInt(idProyectoParam.trim());
            } catch (NumberFormatException e) {
                request.setAttribute("error", "ID de proyecto inválido");
                idProyecto = 0;
            }
        } else {
            request.setAttribute("error", "Falta el parámetro idProyecto");
        }

        // --- CARGAR PROYECTO Y ETAPAS (SIEMPRE) ---
        Proyecto proyecto = null;
        List<Etapa> etapas = new ArrayList<>();

        if (idProyecto > 0) {
            try {
                proyecto = pdao.getById(idProyecto);
            } catch (DAOException e) {
                request.setAttribute("error", "Proyecto no encontrado");
            }

            try {
                etapas = edao.getByProyectoId(idProyecto);
            } catch (DAOException e) {
                request.setAttribute("error", "Error al cargar etapas: " + e.getMessage());
            }
        }

        // --- PASAR DATOS COMUNES ---
        request.setAttribute("proyecto", proyecto);
        request.setAttribute("etapas", etapas);
        request.setAttribute("idProyecto", idProyecto);

        System.out.println("idProyecto que recibe la etapa: " + idProyecto);
        System.out.println("Etapas encontradas: " + etapas.size());
        for (Etapa e : etapas) {
            System.out.println("Etapa: " + e.getNombre() + " | Estado: " + e.getEstado());
        }
        
        System.out.println("=== EDIT DEBUG ===");
        System.out.println("action: " + action);
        System.out.println("id parámetro: " + request.getParameter("id"));
        System.out.println("idProyecto: " + request.getParameter("idProyecto"));

        // --- ACCIONES (TAL COMO LAS TENÍAS) ---
        if ("new".equals(action)) {
            String currentDate = sdf.format(new Date());
            request.setAttribute("fechaInicio", currentDate);
            request.setAttribute("abrirModal", true);
        } else if ("edit".equals(action)) {
            int editId = Integer.parseInt(request.getParameter("id"));
            Etapa etapa = cargarEtaSeguro(request, editId);
            request.setAttribute("id", etapa.getId());
            request.setAttribute("nombre", etapa.getNombre());
            request.setAttribute("descripcion", etapa.getDescripcion());
            request.setAttribute("estado", etapa.getEstado());
            if (etapa.getFechaInicio() != null) {
                request.setAttribute("fechaInicio", sdf.format(etapa.getFechaInicio()));
            } else {
                request.setAttribute("fechaInicio", ""); // o fecha actual
            }
            if (etapa.getFechaTentativa() != null) {
                request.setAttribute("fechaTentativa", sdf.format(etapa.getFechaTentativa()));
            }
            if (etapa.getFechaFin() != null) {
                request.setAttribute("fechaFin", sdf.format(etapa.getFechaFin()));
            }
            request.setAttribute("abrirModal", true);
        } else if ("delete".equals(action)) {
            int deleteId = Integer.parseInt(request.getParameter("id"));
            Etapa eta = cargarEtaSeguro(request, deleteId);
            request.setAttribute("etapa", eta);

            try {
                edao.delete(deleteId);
            } catch (DAOException e) {
                request.setAttribute("error", e.getMessage());
                request.getRequestDispatcher("etapas/listado.jsp").forward(request, response);
                return;
            }
        }

        // --- CARGAR ETAPAS DE NUEVO (tu lógica) ---
        request.setAttribute("etapas", cargarEtapasSeguro(request));

        // --- FORWARD ---
        request.getRequestDispatcher("proyectos/unProyecto.jsp").forward(request, response);
    }

    // --- DO POST (TU LÓGICA EXACTA) ---
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {

        Usuario usuario = (Usuario) request.getSession().getAttribute("usuario");
        if (usuario == null || !"Administrador".equalsIgnoreCase(usuario.getRol())) {
            response.sendRedirect("login.jsp");
            return;
        }

        int id = request.getParameter("id") == null || request.getParameter("id").isEmpty()
                ? 0 : Integer.parseInt(request.getParameter("id"));

        String nombre = request.getParameter("nombre");
        String descripcion = request.getParameter("descripcion");
        String estado = request.getParameter("estado");
        String fechaIni = request.getParameter("fechaInicio");
        String fechaTenta = request.getParameter("fechaTentativa");
        String fechaFi = request.getParameter("fechaFin");

        // --- VALIDAR idProyecto ---
        int idProyecto = 0;
        String idProyectoParam = request.getParameter("idProyecto");
        if (idProyectoParam == null || idProyectoParam.trim().isEmpty()) {
            request.setAttribute("error", "Falta idProyecto");
            request.setAttribute("idProyecto", 0);
            request.setAttribute("action", "list");
            doGet(request, response);
            return;
        }
        try {
            idProyecto = Integer.parseInt(idProyectoParam.trim());
        } catch (NumberFormatException e) {
            request.setAttribute("error", "ID de proyecto inválido");
            request.setAttribute("idProyecto", 0);
            request.setAttribute("action", "list");
            doGet(request, response);
            return;
        }

        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");

        // --- FECHA INICIO ---
        java.sql.Date sqlInicio = null;
        if (fechaIni != null && !fechaIni.trim().isEmpty()) {
            try {
                sqlInicio = new java.sql.Date(sdf.parse(fechaIni).getTime());
            } catch (ParseException e) {
                e.printStackTrace();
            }
        } else {
            throw new IllegalArgumentException("Fecha de inicio es obligatoria");
        }

        // --- FECHA TENTATIVA ---
        java.sql.Date sqlTentativa = null;
        if (fechaTenta != null && !fechaTenta.trim().isEmpty()) {
            try {
                sqlTentativa = new java.sql.Date(sdf.parse(fechaTenta).getTime());
            } catch (ParseException e) {
                throw new IllegalArgumentException("Fecha tentativa inválida");
            }
        }

        // --- FECHA FIN ---
        java.sql.Date sqlFin = null;
        if (fechaFi != null && !fechaFi.trim().isEmpty()) {
            try {
                sqlFin = new java.sql.Date(sdf.parse(fechaFi).getTime());
            } catch (ParseException e) {
                throw new IllegalArgumentException("Fecha fin inválida");
            }
        }

        Etapa eta = new Etapa();
        eta.setId(id);
        eta.setNombre(nombre);
        eta.setDescripcion(descripcion);
        eta.setEstado(estado);
        eta.setFechaInicio(sqlInicio);
        eta.setFechaTentativa(sqlTentativa);
        eta.setFechaFin(sqlFin);
        eta.setIdProyecto(idProyecto);
        eta.setTareas(new java.util.LinkedList<>());
        
        //PARA DEBUG
        System.out.println("=== ETAPA GUARDADA ===");
        System.out.println("ID: " + id);
        System.out.println("Nombre: " + nombre);
        System.out.println("Estado: " + estado);
        System.out.println("idProyecto: " + idProyecto);
        System.out.println("Fecha Inicio: " + sqlInicio);
        System.out.println("Fecha Tentativa: " + sqlTentativa);
        System.out.println("Fecha Fin: " + sqlFin);

        try {
            if (id > 0) {
                edao.update(eta);
            } else {
                edao.insert(eta);
            }
            response.sendRedirect("EtapaServlet?action=view&idProyecto=" + idProyecto);

        } catch (DAOException e) {
            request.setAttribute("error", e.getMessage());
            request.setAttribute("idProyecto", idProyecto);
            request.setAttribute("action", "list");
            doGet(request, response); // ← ¡CARGA PROYECTO Y ETAPAS!
            return;
        }
    }
}