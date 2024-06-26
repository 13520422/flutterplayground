import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:playground/component/component.dart';
import 'package:playground/extension/extension.dart';
import 'package:playground/widget/add_component.dart';
import 'package:uuid/uuid.dart';

class CCColumn extends Component {
  static const String runType = "CCColumn";
  MainAxisAlignment? mainAxisAlignment;
  MainAxisSize? mainAxisSize;
  CrossAxisAlignment? crossAxisAlignment;
  CCColumn({
    required String name,
    required Function(Component?) onUpdate,
    required Function(Component) onDelete,
    Function(Component)? onWrap,
    Function(Component)? onWrapChildren,
  }) {
    super.name = name;
    super.onUpdate = onUpdate;
    super.onDelete = onDelete;
    super.onWrap = onWrap;
    super.onWrapChildren = onWrapChildren;
  }

  @override
  Component copyWith({
    String? name,
    Function(Component?)? onUpdate,
    Function(Component)? onDelete,
    Function(Component)? onWrap,
    Function(Component)? onWrapChildren,
    List<Component>? children,
    MainAxisAlignment? mainAxisAlignment,
    MainAxisSize? mainAxisSize,
    CrossAxisAlignment? crossAxisAlignment,
  }) {
    var column = CCColumn(
      name: name ?? this.name!,
      onUpdate: onUpdate ?? this.onUpdate!,
      onDelete: onDelete ?? this.onDelete!,
      onWrap: onWrap ?? this.onWrap,
      onWrapChildren: onWrapChildren ?? this.onWrapChildren,
    );
    column.children = children ?? this.children.map((e) => e.copyWith()).toList();
    column.mainAxisAlignment = mainAxisAlignment ?? this.mainAxisAlignment;
    column.mainAxisSize = mainAxisSize ?? this.mainAxisSize;
    column.crossAxisAlignment = crossAxisAlignment ?? this.crossAxisAlignment;
    return column;
  }

  static CCColumn? fromJson(Map<String, dynamic> json) {
    // TODO: implement fromJson
    var component = CCColumn(
      name: json["name"],
      onUpdate: (p0) {},
      onDelete: (p0) {},
    );
    component.mainAxisAlignment = MainAxisAlignment.center.fromJson(json["mainAxisAlignment"]);
    component.mainAxisSize = MainAxisSize.min.fromJson(json["mainAxisSize"]);
    component.crossAxisAlignment = CrossAxisAlignment.center.fromJson(json["crossAxisAlignment"]);
    if (json["children"] != null) {
      for (var element in json["children"]) {
        var c = Component.fromJson(element);
        if (c != null) {
          component.children.add(c);
        }
      }
    }
    return component;
  }

  static CCColumn? fromWidget(Column widget) {
    var uuid = Uuid();
    // TODO: implement fromJson
    var component = CCColumn(
      name: uuid.v4(),
      onUpdate: (p0) {},
      onDelete: (p0) {},
    );
    component.mainAxisAlignment = widget.mainAxisAlignment;
    component.mainAxisSize = widget.mainAxisSize;
    component.crossAxisAlignment = widget.crossAxisAlignment;
    if (widget.children.isNotEmpty) {
      for (var element in widget.children) {
        var c = Component.fromWidget(element);
        if (c != null) {
          component.children.add(c);
        }
      }
    }
    return component;
  }

  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json["runtimeType"] = CCColumn.runType;
    json["name"] = name;
    json["mainAxisAlignment"] = mainAxisAlignment?.name;
    json["mainAxisSize"] = mainAxisSize?.name;
    json["crossAxisAlignment"] = crossAxisAlignment?.name;
    json["children"] = children.map((e) => e.toJson()).toList();
    return json;
  }

  @override
  Widget toWidgetViewer(BuildContext context) {
    // TODO: implement toWidget
    return Column(
      key: UniqueKey(),
      crossAxisAlignment: crossAxisAlignment ?? CrossAxisAlignment.center,
      mainAxisAlignment: mainAxisAlignment ?? MainAxisAlignment.start,
      mainAxisSize: mainAxisSize ?? MainAxisSize.max,
      children: children.map((e) => e.toWidgetViewer(context)).toList(),
    );
  }

  @override
  Widget toWidget(BuildContext context) {
    // TODO: implement toWidget
    return Column(
      crossAxisAlignment: crossAxisAlignment ?? CrossAxisAlignment.center,
      mainAxisAlignment: mainAxisAlignment ?? MainAxisAlignment.start,
      mainAxisSize: mainAxisSize ?? MainAxisSize.max,
      children: children.map((e) => e.toWidgetViewer(context)).toList(),
    );
  }

  @override
  Widget toWidgetProperties(
    BuildContext context, {
    Function(Component?)? onUpdate,
    Function(Component)? onDelete,
    Function(Component)? onWrap,
    Function(Component)? onWrapChildren,
  }) {
    if (onUpdate != null) {
      this.onUpdate = onUpdate;
    }
    if (onDelete != null) {
      this.onDelete = onDelete;
    }
    if (onWrap != null) {
      this.onWrap = onWrap;
    }
    if (onWrapChildren != null) {
      this.onWrapChildren = onWrapChildren;
    }
    // TODO: implement toWidget
    return StatefulBuilder(builder: (thisLowerContext, innerSetState) {
      return GestureDetector(
        onTap: () {
          isExpand.value = !isExpand.value;
        },
        child: Obx(() {
          if (!isExpand.value) {
            return Container(
              margin: const EdgeInsets.only(left: 10),
              padding: EdgeInsets.all(5),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text("Column $name ${child != null ? "..." : ""}"),
                      IconButton(
                          onPressed: () {
                            onDelete?.call(this);
                          },
                          icon: Icon(Icons.close, size: 20)),
                      IconButton(
                          onPressed: () {
                            Component.copyComponent = copyWith();
                          },
                          icon: Icon(Icons.copy, size: 20))
                    ],
                  ),
                  SizedBox(width: 5),
                  ...children
                      .map((e) => e.toWidgetProperties(
                            context,
                            onUpdate: (Component? component) {
                              if (component != null) {
                                children.add(component);
                                onUpdate?.call(null);
                              }
                              onUpdate?.call(null);
                              innerSetState.call(() {});
                            },
                            onDelete: (Component component) {
                              children.removeWhere((element) => element == component);
                              onUpdate?.call(null);
                              innerSetState.call(() {});
                            },
                            onWrap: (Component parent) {
                              var index = children.indexWhere((element) => element == parent.child);
                              if (index >= 0) {
                                children.removeAt(index);
                                children.insert(index, parent);
                                children[index].onDelete = (p0) {
                                  children.removeAt(index);
                                  onUpdate?.call(null);
                                  innerSetState.call(() {});
                                };
                              }
                            },
                            onWrapChildren: (Component parent) {
                              ///
                              var index = children.indexWhere((element) => element == parent.children.first);
                              if (index >= 0) {
                                children.removeAt(index);
                                children.insert(index, parent);
                                children[index].onDelete = (p0) {
                                  children.removeAt(index);
                                  onUpdate?.call(null);
                                  innerSetState.call(() {});
                                };
                              }
                            },
                          ))
                      .toList()
                ],
              ),
            );
          }
          return Container(
            margin: const EdgeInsets.only(
              left: 10,
            ),
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Column $name"),
                SizedBox(
                  height: 5,
                ),

                ///control
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      AddComponent(
                        onPressed: (BuildContext context) async {
                          /// add child
                          Component.addComponent(
                            context: context,
                            childCount: 0,
                            onUpdate: (Component? component) {
                              if (component != null) {
                                children.add(component);
                                onUpdate?.call(null);
                              }
                              onUpdate?.call(null);
                              innerSetState.call(() {});
                            },
                            onDelete: (Component component) {
                              children.removeWhere((element) => element == component);
                              onUpdate?.call(null);
                              innerSetState.call(() {});
                            },
                            onWrap: (Component parent) {
                              var index = children.indexWhere((element) => element == parent.child);
                              if (index >= 0) {
                                children.removeAt(index);
                                children.insert(index, parent);
                                children[index].onDelete = (p0) {
                                  children.removeAt(index);
                                  onUpdate?.call(null);
                                  innerSetState.call(() {});
                                };
                              }
                            },
                            onWrapChildren: (Component parent) {
                              ///
                              var index = children.indexWhere((element) => element == parent.children.first);
                              if (index >= 0) {
                                children.removeAt(index);
                                children.insert(index, parent);
                                children[index].onDelete = (p0) {
                                  children.removeAt(index);
                                  onUpdate?.call(null);
                                  innerSetState.call(() {});
                                };
                              }
                            },
                          );
                        },
                      ),
                      AddComponent(
                        text: "Wrap by\nComponent",
                        onPressed: (BuildContext context) async {
                          /// add parent
                          Component.addComponent(
                            context: context,
                            childCount: 0,
                            onUpdate: (Component? parent) {
                              if (parent != null) {
                                parent.child = this;
                                onDelete = (p0) {
                                  parent.child = null;
                                  onUpdate?.call(null);
                                };
                                onWrap?.call(parent);
                              }
                              onUpdate?.call(null);
                              innerSetState.call(() {});
                            },
                            onDelete: onDelete!,
                            onWrap: onWrap!,
                            onWrapChildren: onWrapChildren!,
                            isChild: true,
                          );
                        },
                      ),
                      AddComponent(
                        text: "Wrap by\nChildren Component",
                        onPressed: (BuildContext context) async {
                          /// add parent
                          Component.addComponent(
                            context: context,
                            childCount: 0,
                            onUpdate: (Component? parent) {
                              if (parent != null) {
                                parent.children.add(this);
                                onDelete = (p0) {
                                  parent.children.removeWhere((element) => element == this);
                                  onUpdate?.call(null);
                                  innerSetState.call(() {});
                                };
                                onWrapChildren?.call(parent);
                              }
                              onUpdate?.call(null);
                              innerSetState.call(() {});
                            },
                            onDelete: onDelete!,
                            onWrap: onWrap!,
                            onWrapChildren: onWrapChildren!,
                            isChildren: true,
                          );
                        },
                      ),
                      ElevatedButton(
                        onPressed: () {
                          /// add child
                          onDelete?.call(this);
                        },
                        child: Text('Remove'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          /// add child
                          Component.copyComponent = copyWith();
                        },
                        child: Text('Copy'),
                      ),
                    ],
                  ),
                ),

                ///name
                Container(
                  width: MediaQuery.of(context).size.width * widthDefaultComponent,
                  alignment: Alignment.centerLeft,
                  child: TextFormField(
                    decoration: InputDecoration(labelText: 'Name'),
                    keyboardType: TextInputType.text,
                    initialValue: name,
                    onChanged: (value) {
                      name = value;
                      onUpdate?.call(null);
                    },
                  ),
                ),

                ///style
                Container(
                  width: MediaQuery.of(context).size.width * widthDefaultComponent,
                  alignment: Alignment.centerLeft,
                  child: Builder(builder: (c) {
                    return TextFormField(
                        key: UniqueKey(),
                        decoration: InputDecoration(labelText: 'MainAxisAlignment'),
                        keyboardType: TextInputType.text,
                        initialValue: mainAxisAlignment != null ? "$mainAxisAlignment" : null,
                        onChanged: (value) {
                          onUpdate?.call(null);
                        },
                        onTap: () {
                          ///
                          Component.selectMainAxisAlignment(
                            context: c,
                            callBack: (MainAxisAlignment? align) {
                              innerSetState.call(() {
                                mainAxisAlignment = align;
                              });
                              onUpdate?.call(null);
                            },
                          );
                        });
                  }),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * widthDefaultComponent,
                  alignment: Alignment.centerLeft,
                  child: Builder(builder: (c) {
                    return TextFormField(
                        key: UniqueKey(),
                        decoration: InputDecoration(labelText: 'CrossAxisAlignment'),
                        keyboardType: TextInputType.text,
                        initialValue: crossAxisAlignment != null ? "$crossAxisAlignment" : null,
                        onChanged: (value) {
                          onUpdate?.call(null);
                        },
                        onTap: () {
                          ///
                          Component.selectCrossAxisAlignment(
                            context: c,
                            callBack: (CrossAxisAlignment? align) {
                              innerSetState.call(() {
                                crossAxisAlignment = align;
                              });
                              onUpdate?.call(null);
                            },
                          );
                        });
                  }),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * widthDefaultComponent,
                  alignment: Alignment.centerLeft,
                  child: Builder(builder: (c) {
                    return TextFormField(
                        key: UniqueKey(),
                        decoration: InputDecoration(labelText: 'MainAxisSize'),
                        keyboardType: TextInputType.text,
                        initialValue: mainAxisSize != null ? "$mainAxisSize" : null,
                        onChanged: (value) {
                          onUpdate?.call(null);
                        },
                        onTap: () {
                          ///
                          Component.selectMainAxisSize(
                            context: c,
                            callBack: (MainAxisSize? size) {
                              innerSetState.call(() {
                                mainAxisSize = size;
                              });
                              onUpdate?.call(null);
                            },
                          );
                        });
                  }),
                ),

                SizedBox(height: 5),
                ...children
                    .map((e) => e.toWidgetProperties(
                          context,
                          onUpdate: (Component? component) {
                            if (component != null) {
                              children.add(component);
                              onUpdate?.call(null);
                            }
                            onUpdate?.call(null);
                            innerSetState.call(() {});
                          },
                          onDelete: (Component component) {
                            children.removeWhere((element) => element == component);
                            onUpdate?.call(null);
                            innerSetState.call(() {});
                          },
                          onWrap: (Component parent) {
                            var index = children.indexWhere((element) => element == parent.child);
                            if (index >= 0) {
                              children.removeAt(index);
                              children.insert(index, parent);
                              children[index].onDelete = (p0) {
                                children.removeAt(index);
                                onUpdate?.call(null);
                                innerSetState.call(() {});
                              };
                            }
                          },
                          onWrapChildren: (Component parent) {
                            ///
                            var index = children.indexWhere((element) => element == parent.children.first);
                            if (index >= 0) {
                              children.removeAt(index);
                              children.insert(index, parent);
                              children[index].onDelete = (p0) {
                                children.removeAt(index);
                                onUpdate?.call(null);
                                innerSetState.call(() {});
                              };
                            }
                          },
                        ))
                    .toList()
              ],
            ),
          );
        }),
      );
    });
  }
}
