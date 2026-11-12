package util;

import java.util.List;
public class Pagination1 {
    public static final int PAGE_SIZE = 5;
    private Pagination1() {
    }
    public static int totalPages(int totalItems) {
        return Math.max(1, (totalItems + PAGE_SIZE - 1) / PAGE_SIZE);
    }
    public static int currentPage(String pageParam, int totalPages) {
        int p = 1;
        try {
            p = Integer.parseInt(pageParam);
        } catch (NumberFormatException e) {
            p = 1;
        }
        return Math.min(Math.max(p, 1), totalPages);
    }
    /** Lay cac phan tu cua trang hien tai. */
    public static <T> List<T> slice(List<T> list, int currentPage) {
        int from = Math.min((currentPage - 1) * PAGE_SIZE, list.size());
        int to = Math.min(from + PAGE_SIZE, list.size());
        return list.subList(from, to);
    }
    /** So thu tu cua dong dau tien tren trang hien tai (de danh STT lien tuc). */
    public static int firstIndex(int currentPage) {
        return (currentPage - 1) * PAGE_SIZE + 1;
    }
    /**
     * Sinh HTML thanh phan trang: dong "Hiển thị 1–5 / 9 kết quả" va cac nut ‹ 1 2 … 9 ›.
     * baseUrl da chua dau '?' va tham so tu khoa, vi du "GDSearchDish1.jsp?txtDishName=Ga".
     */
    public static String links(String baseUrl, int currentPage, int totalPages, int totalItems) {
        if (totalItems == 0) {
            return "";
        }
        int from = firstIndex(currentPage);
        int to = Math.min(currentPage * PAGE_SIZE, totalItems);
        StringBuilder sb = new StringBuilder("<nav class=\"pager\" aria-label=\"Phân trang\">");
        sb.append("<span class=\"pager-info\">Hiển thị <b>").append(from).append("–").append(to)
          .append("</b> / ").append(totalItems).append(" kết quả</span>");
        if (totalPages > 1) {
            sb.append("<div class=\"pager-pages\">");
            sb.append(button(baseUrl, currentPage - 1, "‹", currentPage == 1, false, "Trang trước"));
            int last = 0;
            for (int i = 1; i <= totalPages; i++) {
                // luon hien trang dau, trang cuoi va 1 trang moi ben trang hien tai
                if (i == 1 || i == totalPages || Math.abs(i - currentPage) <= 1) {
                    if (last != 0 && i - last > 1) {
                        sb.append("<span class=\"pager-gap\">…</span>");
                    }
                    sb.append(button(baseUrl, i, String.valueOf(i), false, i == currentPage, "Trang " + i));
                    last = i;
                }
            }
            sb.append(button(baseUrl, currentPage + 1, "›", currentPage == totalPages, false, "Trang sau"));
            sb.append("</div>");
        }
        return sb.append("</nav>").toString();
    }
    private static String button(String baseUrl, int page, String label, boolean disabled, boolean current, String title) {
        if (current) {
            return "<span class=\"pager-btn current\" aria-current=\"page\">" + label + "</span>";
        }
        if (disabled) {
            return "<span class=\"pager-btn disabled\">" + label + "</span>";
        }
        return "<a class=\"pager-btn\" title=\"" + title + "\" href=\"" + baseUrl + "&page=" + page + "\">" + label + "</a>";
    }
}