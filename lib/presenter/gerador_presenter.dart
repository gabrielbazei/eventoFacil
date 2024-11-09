abstract class GenerateQRCodeView {
  void updateQRCode(String qrData);
}

class GenerateQRCodePresenter {
  final GenerateQRCodeView view;

  GenerateQRCodePresenter(this.view);

  // Método para obter o QR code (pode ser estendido para buscar de um servidor, etc.)
  void loadQRCode(String id) {
    // Simula a recuperação do ID do aluno
    view.updateQRCode(id);
  }
}
