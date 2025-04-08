import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/category.dart';
import '../utilities/categoryutils.dart';
import '../widgets/home_appbar.dart';
import '../providers/product_provider.dart';
import '../models/product.dart';
import 'upload.dart';
import 'productdetail.dart';
import 'cart.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String selectedCategory = CategoryUtils.categories[0];
  String? filterCategory;
  DateTime? lastTapTime;

  void handleCategoryTap(String category) {
    final now = DateTime.now();
    if (lastTapTime != null &&
        now.difference(lastTapTime!) < const Duration(milliseconds: 500) &&
        category == selectedCategory) {
      setState(() {
        filterCategory = null;
        selectedCategory = '';
        lastTapTime = null;
      });
    } else {
      setState(() {
        selectedCategory = category;
        filterCategory = category;
        lastTapTime = now;
      });
    }
  }

  List<Product> getFilteredProducts(List<Product> products) {
    if (filterCategory == null) {
      return products;
    }
    return products
        .where((product) => product.category == filterCategory)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HomeAppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart, color: Colors.black),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CartPage(),
                ),
              );
            },
          ),
        ],
      ),
      body: Container(
        color: Colors.white,
        child: Consumer<ProductProvider>(
          builder: (context, productProvider, _) {
            final filteredProducts =
                getFilteredProducts(productProvider.products);

            return Column(
              children: [
                Container(
                  height: 120,
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: CategoryUtils.categories.map((category) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: CategoryButton(
                            title: category,
                            isSelected: selectedCategory == category,
                            onTap: () => handleCategoryTap(category),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                Expanded(
                  child: filteredProducts.isEmpty
                      ? const Center(
                          child: Text('등록된 상품이 없습니다.'),
                        )
                      : GridView.builder(
                          padding: const EdgeInsets.all(16),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.65,
                            mainAxisSpacing: 16,
                            crossAxisSpacing: 16,
                          ),
                          itemCount: filteredProducts.length,
                          itemBuilder: (context, index) {
                            final product = filteredProducts[index];
                            return Card(
                              elevation: 2,
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ProductDetailPage(
                                        id: product.id,
                                      ),
                                    ),
                                  );
                                },
                                child: Stack(
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: Container(
                                            width: double.infinity,
                                            decoration: BoxDecoration(
                                              color: Colors.grey[200],
                                              borderRadius:
                                                  const BorderRadius.vertical(
                                                top: Radius.circular(4),
                                              ),
                                            ),
                                            child: Image.file(
                                              product.image,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: SingleChildScrollView(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  product.name,
                                                  style: const TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                                const SizedBox(height: 4),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      '${product.price}원',
                                                      style: const TextStyle(
                                                        fontSize: 12,
                                                        color: Colors.green,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    Text(
                                                      product.category,
                                                      style: TextStyle(
                                                        fontSize: 11,
                                                        color: Colors.grey[600],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Positioned(
                                      top: 4,
                                      right: 4,
                                      child: GestureDetector(
                                        onTap: () {
                                          showDialog(
                                            context: context,
                                            builder: (context) => AlertDialog(
                                              title: const Text('상품 삭제'),
                                              content:
                                                  const Text('이 상품을 삭제하시겠습니까?'),
                                              actions: [
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: const Text('취소'),
                                                ),
                                                TextButton(
                                                  onPressed: () {
                                                    productProvider
                                                        .removeProduct(
                                                            product.id);
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: const Text('삭제'),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.all(4),
                                          decoration: BoxDecoration(
                                            color:
                                                Colors.black.withOpacity(0.5),
                                            shape: BoxShape.circle,
                                          ),
                                          child: const Icon(
                                            Icons.close,
                                            color: Colors.white,
                                            size: 16,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ],
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const UploadPage()),
          );
        },
        backgroundColor: Colors.green,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
