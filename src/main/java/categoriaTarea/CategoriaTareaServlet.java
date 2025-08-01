package categoriaTarea;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * Servlet implementation class ServletCategoriaTarea
 */
@WebServlet("/CategoriaTareaServlet")
public class CategoriaTareaServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private CategoriaTareaDAO dao;

    @Override
    public void init() {
        dao = new CategoriaTareaDAO();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");

        if (action == null) action = "list";

        switch (action) {
            case "edit":
                int editId = Integer.parseInt(request.getParameter("id"));
                CategoriaTarea catEdit = dao.getById(editId);
                request.setAttribute("id", catEdit.getId());
                request.setAttribute("nombre", catEdit.getNombre());
                request.setAttribute("descripcion", catEdit.getDescripcion());
                break;

            case "delete":
                int deleteId = Integer.parseInt(request.getParameter("id"));
                dao.delete(deleteId);
                break;
        }

        request.setAttribute("categorias", dao.getAll());
        request.getRequestDispatcher("categoriaTarea.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int id = request.getParameter("id") == null || request.getParameter("id").isEmpty()
                 ? 0 : Integer.parseInt(request.getParameter("id"));
        String nombre = request.getParameter("nombre");
        String descripcion = request.getParameter("descripcion");

        CategoriaTarea cat = new CategoriaTarea();
        cat.setId(id);
        cat.setNombre(nombre);
        cat.setDescripcion(descripcion);

        if (id > 0) {
            dao.update(cat);
        } else {
            dao.insert(cat);
        }

        response.sendRedirect("CategoriaTareaServlet");
    }

}
