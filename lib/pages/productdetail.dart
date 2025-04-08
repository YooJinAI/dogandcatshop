// 상품 상세 페이지
// 선택한 상품의 상세 정보를 보여주고 장바구니에 추가하거나 바로 구매할 수 있는 화면
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';
import '../providers/cart_provider.dart';
import '../widgets/appbar.dart';
import '../widgets/product/product_image_viewer.dart';
import '../widgets/product/product_information.dart';
import '../widgets/product/purchase_actions.dart';
import '../pages/checkout.dart';

class ProductDetailPage extends StatefulWidget {
  final String id;

  const ProductDetailPage({
    super.key,
    required this.id,
  });

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);
    final product = productProvider.getProductById(widget.id);

    if (product == null) {
      return const Scaffold(
        appBar: PageAppBar(),
        body: Center(
          child: Text('상품을 찾을 수 없습니다.'),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const PageAppBar(),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ProductImageViewer(imagePath: product.image),
                    ProductInformation(product: product),
                  ],
                ),
              ),
            ),
            PurchaseActions(
              onAddToCart: () {
                Provider.of<CartProvider>(context, listen: false)
                    .addItem(product);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('장바구니에 추가되었습니다'),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
              onBuyNow: () {
                final cartProvider =
                    Provider.of<CartProvider>(context, listen: false);
                cartProvider.clearCart();
                cartProvider.addItem(product);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CheckoutPage(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
