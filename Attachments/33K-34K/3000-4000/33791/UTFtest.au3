Local $str[11] = [ _
  "Sant Julià de Lòria", _
  "Skrýchov u Opařan", _
  "Hiệp hội Unicode ở California xuất bản phiên bản đầu tiên của The Unicode Standard (Tiêu chuẩn Unicode) vào năm 1991, và vẫn liên tục hoàn thiện chuẩn (hiện nay đã đến phiên bản 4.0). Các phiên bản mới được viết dựa trên các phiên bản đã có, nhờ vậy đảm bảo được tính tương thích. Cũng xin lưu ý rằng Unicode và tiêu chuẩn ISO 10646 là hai khái niệm hoàn toàn độc lập. Khi nói đến ISO 10646 tức là người ta đang nói đến tiêu chuẩn quốc tế chính thức, còn Unicode thì được Unicode Consortium (tập hợp đại diện các công ty tin học lớn) soạn ra. Kể từ năm 1991, khi Nhóm làm việc ISO và Liên đoàn Unicode quyết định hợp tác chặt chẽ với nhau trong quá trình nâng cấp và mở rộng chuẩn để đảm bảo tính tương thích (cụ thể là vị trí của các ký tự trên cả hai đều y hệt nhau – chẳng hạn chữ ơ là 01A1). Còn với Unicode thì lại khác, chuẩn này được phát triển bởi Liên đoàn Unicode. Liên đoàn Unicode là một tổ chức phi lợi nhuận tập hợp bởi một số công ty, trong đó có cả những công ty đa quốc gia khổng lồ có ảnh hưởng lớn như Microsoft, Adobe Systems, IBM, Novell, Sun Microsystems, Lotus Software, Symantec và Unisys. (Danh sách đầy đủ tại: [1]). Tuy nhiên, chuẩn Unicode không chỉ quy định bộ mã, mà còn cả cách dựng hình, cách mã hóa (sử dụng 1, 2, 3 hay 4 byte để biểu diễn một ký tự (UTF-8 là một ví dụ), sự tương quan (collation) giữa các ký tự, và nhiều đặc tính khác của các ký tự, hỗ trợ cả những ngôn ngữ từ phải sang trái như tiếng Ả Rập chẳng hạn.", _
  "Žíšov", _
  "БОЛЬШОЕ ГРИДИНО", _
  "МЫТИЩИ-ДТИ", _
  "歴史的仮名遣", _
  "変体仮名", _
  " فرنسيّ عربيّ", _
  "सभी मनुष्यों को गौरव और अधिकारों के मामले में जन्मजात स्वतन्त्रता और समानता प्राप्त है। उन्हें बुद्धि और अन्तरात्मा की देन है और परस्पर उन्हें भाईचारे के भाव से बर्ताव करना चाहिये।", _
  "เขาจะได้ไปเที่ยวเมืองลาว" _
]

For $s In $str
	MsgBox(0, "Unicode test", $s)
Next
