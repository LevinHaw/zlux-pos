import 'package:zlux_pos/core/enum/app_language.dart';
import 'package:zlux_pos/core/enum/app_theme_mode.dart';

class AppLocalizations {
  final AppLanguage language;
  const AppLocalizations(this.language);

  bool get _id => language == AppLanguage.id;

  String get appName => 'ZLux POS';

  String get onboard => _id ? 'Kelola Merchant' : 'Manage Merchant';
  String get subOnboard =>
      _id
          ? 'Sentralisasi semuanya, perbarui profil dan kelola produk Anda'
          : 'Centralize everything, update your profile and manage your product';
  String get onboard2 => _id ? 'Catatan Bulanan' : 'Monthly Record';
  String get subOnboard2 =>
      _id
          ? 'Tak perlu lagi mencatat manual, evaluasi performa bisnis dan pantau pertumbuhan bulanan'
          : 'Say goodbye to manual bookkeeping, evaluate your business performance and monitor monthly growth';
  String get onboard3 => _id ? 'Tap, Cetak, Selesai!' : 'Tap, Print, And Done!';
  String get subOnboard3 =>
      _id
          ? 'Bangun kepercayaan pelanggan dan percepat checkout hanya dengan satu tap'
          : 'Build trust with your customer and speed up your checkout with one tap';

  String get email => _id ? 'Email' : 'Email';
  String get password => _id ? 'Kata sandi' : 'Password';
  String get login => _id ? 'Masuk' : 'Login';
  String get forgotPassword => _id ? 'Lupa kata sandi' : 'Forgot password';
  String get notHaveAccount =>
      _id ? 'Belum punya akun?' : "Dont have any account?";
  String get signup => _id ? 'Daftar' : 'Sign up';
  String get username => _id ? 'Nama pengguna' : 'Username';
  String get phoneNumber => _id ? 'Nomor telepon' : 'Phone number';
  String get alreadyHaveAccount =>
      _id ? 'Sudah punya akun?' : 'Already have an account?';

  String get bussinessData => _id ? 'Data bisnis' : 'Bussiness data';
  String get totalTransactionToday =>
      _id ? 'Total transaksi hari ini' : 'Total transaction today';
  String get amount => _id ? 'Jumlah' : 'Amount';
  String get brandMerchant => _id ? 'Brand / Merchant' : 'Brand / Merchant';
  String get itemsPerOrder => _id ? 'Item per pesanan' : 'Item per order';
  String get averageOrder => _id ? 'Rata-rata pesanan' : 'Average order';

  String get dailyReport => _id ? 'Laporan harian' : 'Daily report';
  String get reportTransactionIncome =>
      _id ? 'Pendapatan dari transaksi' : 'Income from transactions';
  String get reportIncomeEntry =>
      _id ? 'Pendapatan dari income entry' : 'Income from income entries';
  String get reportTotalIncome => _id ? 'Total pendapatan' : 'Total income';
  String get reportTotalExpense =>
      _id ? 'Total pengeluaran' : 'Total expense';
  String get reportProfit => _id ? 'Laba' : 'Profit';
  String get pickReportDate => _id ? 'Pilih tanggal' : 'Pick date';
  String get reportMenu => _id ? 'Laporan' : 'Report';
  String get reportProductDetail =>
      _id ? 'Detail transaksi per produk' : 'Transaction detail per product';
  String get reportPaymentMethod =>
      _id ? 'Metode pembayaran' : 'Payment method';
  String get reportCash => _id ? 'Tunai' : 'Cash';
  String get reportTransfer => _id ? 'Transfer' : 'Transfer';
  String get product => _id ? 'Produk' : 'Product';
  String get quantity => _id ? 'Jumlah' : 'Quantity';
  String get reportDailyNote => _id ? 'Catatan harian' : 'Daily note';
  String get reportDailyNoteHint => _id
      ? 'Contoh: 50 motor, 20 mobil, 70 pelanggan'
      : 'Example: 50 motorcycles, 20 cars, 70 customers';
  String get reportNoteSaved =>
      _id ? 'Catatan tersimpan' : 'Note saved';

  String get home => _id ? 'Beranda' : 'Home';
  String get history => _id ? 'Riwayat' : 'History';
  String get setup => _id ? 'Konfigurasi' : 'Setup';
  String get settings => _id ? 'Pengaturan' : 'Settings';
  String get month => _id ? 'Bulan' : 'Month';

  String get setupMerchant => _id ? 'Atur merchant' : 'Setup merchant';
  String get setupProduct => _id ? 'Atur produk' : 'Setup product';
  String get orderUpdated =>
      _id ? 'Order diperbaharui' : 'Order has been updated';

  String get preferences => _id ? 'Preferensi' : 'Preferences';
  String get lang => _id ? 'Bahasa' : 'Language';
  String get theme => _id ? 'Tema' : 'Theme';

  String get transaction => _id ? 'Transaksi' : 'Transaction';
  String get editTransaction => _id ? 'Edit transaksi' : 'Edit transaction';
  String get payment => _id ? 'Pembayaran' : 'Payment';
  String get total => _id ? 'Total' : 'Total';
  String get checkout => _id ? 'Bayar' : 'Checkout';

  String get historyOrder => _id ? 'Riwayat pesanan' : 'History order';
  String get export => _id ? 'Ekspor' : 'Export';
  String get id => _id ? 'Id' : 'Id';
  String get status => _id ? 'Status' : 'Status';
  String get notes => _id ? 'Catatan' : 'Notes';
  String get edit => _id ? 'Ubah' : 'Edit';
  String get pending => _id ? 'Tertunda' : 'Pending';
  String get finish => _id ? 'Selesai' : 'Finish';
  String get print => _id ? 'Cetak' : 'Print';

  String get nameMerchant => _id ? 'Nama merchant' : 'Name merchant';
  String get address => _id ? 'Alamat' : 'Address';

  String get setupProducts => _id ? 'Atur produk' : 'Setup products';
  String get itemsSale => _id ? 'Item yang dijual' : 'Items on sale';
  String get productList => _id ? 'Daftar produk' : 'Product list';
  String get category => _id ? 'Kategori' : 'Category';
  String get price => _id ? 'Harga' : 'Price';

  String get setupDataIncome =>
      _id ? 'Atur data pemasukkan' : 'Setup data income';
  String get setupDataExpense =>
      _id ? 'Atur data pengeluaran' : 'Setup data expense';

  String get newProduct => _id ? 'Produk baru' : 'New product';
  String get newCategory => _id ? 'Kategori baru' : 'New category';
  String get editProduct => _id ? 'Ubah produk' : 'Edit product';
  String get productName => _id ? 'Nama produk' : 'Product name';

  String get loginTitle => _id ? 'Selamat datang kembali' : 'Welcome back';
  String get loginEmailHint => _id ? 'Email' : 'Email';
  String get loginPasswordHint => _id ? 'Kata sandi' : 'Password';
  String get loginButton => _id ? 'Masuk' : 'Log In';
  String get loginError =>
      _id ? 'Email atau kata sandi salah' : 'Invalid email or password';

  String get errorGeneric =>
      _id
          ? 'Terjadi kesalahan. Silakan coba lagi.'
          : 'Something went wrong. Please try again.';
  String get errorNoConnection =>
      _id ? 'Tidak ada koneksi internet' : 'No internet connection';
  String get retry => _id ? 'Coba lagi' : 'Retry';
  String get cancel => _id ? 'Batal' : 'Cancel';
  String get save => _id ? 'Simpan' : 'Save';
  String get delete => _id ? 'Hapus' : 'Delete';

  String get noPairedPrinter =>
      _id
          ? 'Printer belum ditemukan. Sambungkan lewat pengaturan Bluetooth dahulu.'
          : 'No paired printer found. Pair one in Bluetooth settings first.';
  String get bluetoothPermissionDenied =>
      _id
          ? 'Izin Bluetooth diperlukan untuk mencetak'
          : 'Bluetooth permission is required to print';
  String get printerConnectFailed =>
      _id ? 'Tidak dapat terhubung ke printer' : 'Could not connect to printer';
  String get exportComingSoon =>
      _id ? 'Ekspor segera hadir' : 'Export coming soon';
  String get noOrdersThisDay =>
      _id ? 'Tidak ada pesanan hari ini' : 'No orders on this day';
  String get select => _id ? 'Pilih' : 'Select';
  String get noOrdersThisMonth =>
      _id ? 'Tidak ada pesanan bulan ini' : 'No orders this month';
  String get printFailed => _id ? 'Tidak dapat mencetak' : 'Cannot print';
  String get bluetoothPermissionPermanentlyDenied =>
      _id
          ? 'Izin Bluetooth ditolak. Aktifkan di Pengaturan.'
          : 'Bluetooth permission was denied. Enable it in Settings.';
  String get openSettings => _id ? 'Open Settings' : 'Buka Pengaturan';

  String get checkoutSuccess => _id ? 'Pesanan dibuat' : 'Order created';
  String get deleteOrder => _id ? 'Hapus order' : 'Delete order';
  String get deleteOrderMessage =>
      _id
          ? 'Apakah Anda yakin ingin menghapus pesanan ini?'
          : 'Do you want to delete this order?';
  String get deleteProduct => _id ? 'Hapus produk' : 'Delete product';
  String get deleteProductMessage =>
      _id
          ? 'Apakah Anda yakin ingin menghapus produk ini?'
          : 'Do you want to delete this product?';

  String get income => _id ? 'Pemasukkan' : 'Income';
  String get incomeList => _id ? 'Daftar income' : 'Income list';
  String get otherIncome => _id ? 'Pemasukkan lain' : 'Other income';
  String get otherIncomeName =>
      _id ? 'Nama pemasukkan lain' : 'Other income name';
  String get emptyIncome => _id ? 'Belum ada pemasukkan lain' : 'No income yet';
  String get deleteIncome => _id ? 'Hapus pemasukkan' : 'Delete income';
  String get deleteIncomeMessage =>
      _id
          ? 'Apakah Anda yakin ingin menghapus pemasukkan ini?'
          : 'Do you want to delete this income?';

  String get expense => _id ? 'Pengeluaran' : 'Expense';
  String get expenseList => _id ? 'Daftar pengeluaran' : 'Expense list';
  String get otherExpense => _id ? 'Pengeluaran lain' : 'Other expense';
  String get otherExpenseName =>
      _id ? 'Nama pengeluaran lain' : 'Other expense name';
  String get emptyExpense =>
      _id ? 'Belum ada pengeluaran lain' : 'No expense yet';
  String get deleteExpense => _id ? 'Hapus pengeluaran' : 'Delete expense';
  String get deleteExpenseMessage =>
      _id
          ? 'Apakah Anda yakin ingin menghapus pengeluaran ini?'
          : 'Do you want to delete this expense?';

  String get date => _id ? 'Tanggal' : 'Date';
  String get incomeCategory => _id ? 'Kategori pemasukkan' : 'Income category';
  String get expenseCategory =>
      _id ? 'Kategori pengeluaran' : 'Expense category';

  String get incomeEntry => _id ? 'Catat pemasukkan' : 'Income entry';
  String get incomeEntries => _id ? 'Catat pemasukkan' : 'Income entries';
  String get incomeEntryList => _id ? 'Daftar pemasukkan' : 'Income entry list';
  String get emptyIncomeEntry =>
      _id ? 'Belum ada catatan pemasukkan' : 'No income entries yet';

  String get expenseEntry => _id ? 'Catat pengeluaran' : 'Expense entry';
  String get expenseEntries => _id ? 'Catat pengeluaran' : 'Expense entries';
  String get expenseEntryList =>
      _id ? 'Daftar pengeluaran' : 'Expense entry list';
  String get emptyExpenseEntry =>
      _id ? 'Belum ada catatan pengeluaran' : 'No expense entries yet';

  String get chooseAction => _id ? 'Pilih tindakan' : 'Choose an action';
  String get newTransaction => _id ? 'Transaksi baru' : 'New transaction';
  String get newTransactionSubtitle =>
      _id ? 'Buat pesanan penjualan baru' : 'Create a new sales order';
  String get incomeEntrySubtitle =>
      _id ? 'Catat jumlah pemasukkan lain' : 'Record another income amount';
  String get expenseEntrySubtitle =>
      _id ? 'Catat jumlah pengeluaran' : 'Record an expense amount';

  String themeModeLabel(AppThemeMode mode) {
    switch (mode) {
      case AppThemeMode.light:
        return _id ? 'Terang' : 'Light';
      case AppThemeMode.dark:
        return _id ? 'Gelap' : 'Dark';
    }
  }

  String languageLabel(AppLanguage lang) {
    switch (lang) {
      case AppLanguage.id:
        return 'Indonesia';
      case AppLanguage.en:
        return 'English';
    }
  }
}
