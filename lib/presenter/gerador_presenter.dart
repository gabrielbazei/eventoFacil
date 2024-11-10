abstract class GenerateQRCodeView {
  void updateQRCode(String qrData);
}

class GenerateQRCodePresenter {
  final GenerateQRCodeView view;

  GenerateQRCodePresenter(this.view);

  // Método para obter o QR code
  void loadQRCode(String id) {
    // Simula a recuperação do ID do aluno
    view.updateQRCode(id);
  }
}
