package util;

import java.text.DecimalFormat;
import java.text.DecimalFormatSymbols;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.Locale;

/**
 * Ham tien ich hien thi cho cac trang JSP.
 */
public class Format1 {

    private static final DateTimeFormatter DATE_TIME = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm");

    private Format1() {
    }

    /** Chong loi hien thi/XSS: escape ky tu dac biet HTML. null -> chuoi rong. */
    public static String esc(String s) {
        if (s == null) {
            return "";
        }
        StringBuilder sb = new StringBuilder(s.length());
        for (char c : s.toCharArray()) {
            switch (c) {
                case '<': sb.append("&lt;"); break;
                case '>': sb.append("&gt;"); break;
                case '&': sb.append("&amp;"); break;
                case '"': sb.append("&quot;"); break;
                case '\'': sb.append("&#39;"); break;
                default: sb.append(c);
            }
        }
        return sb.toString();
    }

    /** 180000 -> "180.000 đ" */
    public static String money(double value) {
        DecimalFormat df = new DecimalFormat("#,##0.##", DecimalFormatSymbols.getInstance(Locale.forLanguageTag("vi-VN")));
        return df.format(value) + " đ";
    }

    /** 3.0 -> "3", 2.5 -> "2,5" */
    public static String number(double value) {
        DecimalFormat df = new DecimalFormat("#,##0.###", DecimalFormatSymbols.getInstance(Locale.forLanguageTag("vi-VN")));
        return df.format(value);
    }

    public static String dateTime(LocalDateTime time) {
        return time == null ? "" : time.format(DATE_TIME);
    }

    /** Doc so thuc tu o nhap, chap nhan ca dau phay. Khong hop le -> -1. */
    public static double parsePositive(String s) {
        if (s == null) {
            return -1;
        }
        try {
            double v = Double.parseDouble(s.trim().replace(",", "."));
            return (v > 0 && !Double.isInfinite(v)) ? v : -1;
        } catch (NumberFormatException e) {
            return -1;
        }
    }
}
