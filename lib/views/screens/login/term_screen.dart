import 'dart:io';

import 'package:anytimeworkout/config/icons.dart';

import '../../../config/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class TermScreen extends StatelessWidget {
  const TermScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Builder(builder: (context) {
        return Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: lightColor,
            appBar: AppBar(
              centerTitle: true,
              title: const Text('register.lbl_terms_cond',
                      style: TextStyle(color: blackColor))
                  .tr(),
              elevation: 1,
              leading: ModalRoute.of(context)?.canPop == true
                  ? IconButton(
                      icon: Icon(
                        (context.locale.toString() == "en_US")
                            ? (Platform.isIOS)
                                ? iosBackButton
                                : backArrow
                            : (context.locale.toString() == "ar_AR")
                                ? (Platform.isIOS)
                                    ? iosForwardButton
                                    : forwardArrow
                                : iosForwardButton,
                        color: blackColor,
                      ),
                      onPressed: () => Navigator.of(context).pop(),
                    )
                  : null,
              backgroundColor: lightColor,
            ),
            body: Padding(
                padding: const EdgeInsets.all(10.0),
                child: SingleChildScrollView(
                  child: Column(children: <Widget>[
                    ListTile(
                      title: const Text('Effective Date:- 19 April, 2020',
                          style: TextStyle(fontSize: 14)),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const <Widget>[
                              Text(
                                  'By accessing and using this Website, you are agreeing to be bound by the Website’s Terms of Use and the Privacy Policy (together the “Terms”), all applicable laws and regulations, and agree that you are responsible for compliance with any applicable local laws. If you do not agree with any of these Terms, your sole option is to immediately cease your use of this Website. The materials contained in this Website are protected by applicable copyright and trademark law.'),
                              Text(
                                  'THIS AGREEMENT is made between ANYTIME WORKOUT and you ("the User").')
                            ]),
                      ),
                    ),
                    const Divider(),
                    ListTile(
                      visualDensity:
                          const VisualDensity(horizontal: 0, vertical: 4),
                      title: const Text('1. DEFINITIONS',
                          style: TextStyle(fontSize: 14)),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            const Text(
                              '"Effective Date"',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const Text(
                                'the date on which this set of terms and conditions entered effect.'),
                            const Text(
                                'Permission is granted to temporarily download copies of the materials (information or software) on the Website for personal, non-commercial transitory viewing only.'),
                            const Text('"Intellectual Property Rights"',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            const Text(
                                'all copyrights, patents, registered and unregistered design rights, database rights, trademarks and service marks and applications for any of the foregoing, together with all trade secrets, know-how, rights to confidence and other intellectual and industrial property rights in all parts of the world.'),
                            const Text('"Material"',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            const Text(
                                'content published on the Website or otherwise provided to ANYTIME WORKOUT. For the avoidance of doubt, it includes all content posted on the Website by the User or otherwise provided to ANYTIME WORKOUT by the User'),
                            const Text('"Registration Details"',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            const Text(
                                'the details which a User must provide on registering for the Website including name, phone numbers, email address, age or address.'),
                            const Text('"Service"',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            const Text(
                                'the provision of the Website as a property portal.'),
                            const Text('"Unacceptable"',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            const Text(
                                'Material which under the laws of any jurisdiction from which the Website may be accessed may be considered either:-'),
                            Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const <Widget>[
                                  Text("a. ",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  Expanded(
                                    child: Text(
                                        'illegal, illicit, indecent, obscene, racist, offensive, pornographic, insulting, false, unreliable, misleading, alleged to be or actually defamatory or in infringement of third party rights (of whatever nature and including, without limitation, any Intellectual Property Rights)'),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const <Widget>[
                                  Text("b. ",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  Expanded(
                                    child: Text(
                                        'in breach of any applicable regulations, standards or codes of practice (notwithstanding that compliance may not be compulsory)'),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const <Widget>[
                                  Text("c. ",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  Expanded(
                                    child: Text(
                                        'to contravene legislation, including without limitation, that relating to weapons, animals or alcohol'),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const <Widget>[
                                  Text("d. ",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  Expanded(
                                    child: Text(
                                        'might harm ANYTIME WORKOUT\'s reputation.'),
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const <Widget>[
                                Text('"User"- ',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                Expanded(
                                  child:
                                      Text('any party who uses the Website.'),
                                ),
                              ],
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const <Widget>[
                                Text('"Website"- ',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                Expanded(
                                  child: Text(
                                      'ANYTIME WORKOUT\'s website located at www.uaeaqar.com'),
                                ),
                              ],
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const <Widget>[
                                Text('"ANYTIME WORKOUT"- ',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                Expanded(
                                  child: Text(
                                      'which is the owner of the Website.'),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Divider(),
                    ListTile(
                      visualDensity:
                          const VisualDensity(horizontal: 0, vertical: 4),
                      title: const Text('2.TERMS WHICH APPLY TO USERS',
                          style: TextStyle(fontSize: 14)),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const <Widget>[
                                  Text("2.1. ",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  Expanded(
                                    child: Text(
                                        'In registering for this Website, the User must provide true, accurate, current and complete Registration Details which the User must update after any changes (except age) before using the Website for further services in the future.'),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const <Widget>[
                                  Text("2.2. ",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  Expanded(
                                    child: Text(
                                        'The User hereby warrants to ANYTIME WORKOUT that it is at least eighteen years of age and legally able to enter into contracts.'),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const <Widget>[
                                  Text("2.3. ",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  Expanded(
                                    child: Text(
                                        'ANYTIME WORKOUT reserves the discretion to withdraw any Material from the Website without prior notice and to refuse any Material posted by a User.'),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const <Widget>[
                                  Text("2.4. ",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  Expanded(
                                    child: Text(
                                        'The User\'s Registration Details and data relating to its use of the Website will be recorded by ANYTIME WORKOUT but this information shall not be disclosed to third parties (otherwise than on an aggregated, anonymous basis) nor used for any purpose unrelated to the Website.'),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const <Widget>[
                                  Text("2.5. ",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  Expanded(
                                    child: Text(
                                        'ANYTIME WORKOUT may send a small file to the User\'s computer when it visits the Website. This "cookie" will enable ANYTIME WORKOUT to identify the User\'s computer, track its behavior on the Website and to identify the User\'s particular areas of interest so as to enhance the User\'s future visits to the Website. The cookie will not enable ANYTIME WORKOUT to identify the User and ANYTIME WORKOUT shall not use it otherwise than in relation to this Website. The User can set its computer browser to reject cookies but this may preclude use of certain parts of this Website.'),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const <Widget>[
                                  Text("2.6. ",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  Expanded(
                                    child: Text(
                                        'The User hereby authorizes ANYTIME WORKOUT to use any information which it submits to this Website to inform the User of special offers, occasional third party offers and for other marketing and related purposes. ANYTIME WORKOUT will not use User data for any other purposes than as set out in this Agreement except that ANYTIME WORKOUT may disclose this data if compelled to do so by law, or at the request of a law enforcement agency or governmental authority.'),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const <Widget>[
                                  Text("2.7. ",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  Expanded(
                                    child: Text(
                                        'If the User does not wish ANYTIME WORKOUT to use its information as set out in Clauses 2.3 and 2.4 above, it should leave the Website before submitting its personal details.'),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const <Widget>[
                                  Text("2.8. ",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  Expanded(
                                    child: Text(
                                        'If the User does not want ANYTIME WORKOUT to use its email address or SMS to send information concerning the Website and related matters, the User should send a message to ANYTIME WORKOUT and insert unsubscribe as the subject heading.'),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const <Widget>[
                                  Text("2.9. ",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  Expanded(
                                    child: Text(
                                        'By agreeing to the terms, you give us permission to verify the authenticity of your details by calling you at the submitted phone number, the call will be recorded for quality assurance.'),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const <Widget>[
                                  Text("2.10. ",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  Expanded(
                                    child: Text(
                                        'ANYTIME WORKOUT reserves the right to suspend or terminate a User\'s account where, in its absolute discretion, it deems such suspension appropriate. In the event of such suspension or termination, ANYTIME WORKOUT will notify the User by email and the User must not seek to re-register either directly or indirectly through a related entity.'),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const <Widget>[
                                  Text("2.11. ",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  Expanded(
                                    child: Text(
                                        'For the avoidance of doubt, ANYTIME WORKOUT is providing a service not goods.'),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const <Widget>[
                                  Text("2.12. ",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  Expanded(
                                    child: Text(
                                        'ANYTIME WORKOUT owns all Intellectual Property Rights in the Website and the Service, including without limitation, the design, text, graphics, the selection and arrangement thereof.'),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const <Widget>[
                                  Text("2.13. ",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  Expanded(
                                    child: Text(
                                        'ANYTIME WORKOUT takes reported and actual infringement of Intellectual Property Rights and fraud extremely seriously and whilst Users cannot hold ANYTIME WORKOUT liable in relation to such issues, ANYTIME WORKOUT requests all Users to report such matters immediately and ANYTIME WORKOUT shall inform the appropriate authorities.'),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const <Widget>[
                                  Text("2.14. ",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  Expanded(
                                    child: Text(
                                        'Users will be invited to send comments to ANYTIME WORKOUT by email relating to the integrity and performance of other Users.'),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const <Widget>[
                                  Text("2.15. ",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  Expanded(
                                    child: Text(
                                        'The following restrictions shall apply to all Users:'),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const <Widget>[
                                  SizedBox(width: 40),
                                  Text("• ",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  Expanded(
                                    child: Text(
                                        'User agrees not to transmit any material designed to interrupt, damage, destroy or limit the functionality of the Website or the Service.'),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const <Widget>[
                                  SizedBox(width: 40),
                                  Text("• ",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  Expanded(
                                    child: Text(
                                        'User agrees not to use any automated software to view the Service without consent and to only access the Service manually.'),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const <Widget>[
                                  SizedBox(width: 40),
                                  Text("• ",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  Expanded(
                                    child: Text(
                                        'User agrees not to use the Service other than for its own personal use or as an agent listing properties for sale and to rent.'),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const <Widget>[
                                  SizedBox(width: 40),
                                  Text("• ",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  Expanded(
                                    child: Text(
                                        'User agrees not to attempt to copy any Material or reverse engineer any processes without ANYTIME WORKOUT\'s consent.'),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const <Widget>[
                                  SizedBox(width: 40),
                                  Text("• ",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  Expanded(
                                    child: Text(
                                        'User agrees not to use any Service in any manner that is illegal, immoral or harmful to ANYTIME WORKOUT.'),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const <Widget>[
                                  SizedBox(width: 40),
                                  Text("• ",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  Expanded(
                                    child: Text(
                                        'User agrees not to use any Service in breach of any policy or other notice on the Website.'),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const <Widget>[
                                  SizedBox(width: 40),
                                  Text("• ",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  Expanded(
                                    child: Text(
                                        'User agrees not to remove or alter any copyright notices that appear on the Website.'),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const <Widget>[
                                  SizedBox(width: 40),
                                  Text("• ",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  Expanded(
                                    child: Text(
                                        'User agrees not to publish any Material that may encourage a breach of any relevant laws or regulations.'),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const <Widget>[
                                  SizedBox(width: 40),
                                  Text("• ",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  Expanded(
                                    child: Text(
                                        'User agrees not to interfere with any other User\'s enjoyment of the Website or the Service.'),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const <Widget>[
                                  SizedBox(width: 40),
                                  Text("• ",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  Expanded(
                                    child: Text(
                                        'User agrees not to transmit materials protected by copyright without the permission of the owner.'),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const <Widget>[
                                  SizedBox(width: 40),
                                  Text("• ",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  Expanded(
                                    child: Text(
                                        'User agrees not to conduct itself in an offensive or abusive manner whilst using the Website or the Service.'),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const <Widget>[
                                  SizedBox(width: 40),
                                  Text("• ",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  Expanded(
                                    child: Text(
                                        'Do not Make any unauthorized use of the Site, including collecting usernames and/or email addresses of users to send unsolicited email or creating user accounts under false pretenses.'),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const <Widget>[
                                  SizedBox(width: 40),
                                  Text("• ",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  Expanded(
                                    child: Text(
                                        'Falsely imply a relationship with us or another company with whom you do not have a relationship.'),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const <Widget>[
                                  Text("2.16. ",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  Expanded(
                                    child: Text(
                                        'By submitting Material on the Website or otherwise, User grants ANYTIME WORKOUT a royalty-free, perpetual, irrevocable and non-exclusive right and license to use, reproduce, distribute, display, modify and edit the Material. ANYTIME WORKOUT will not pay the User any fees for the Material and reserves the right in its sole discretion to remove or edit the Material at any time. User also warrants and represents that it has all rights necessary to grant ANYTIME WORKOUT these rights.'),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const <Widget>[
                                  Text("2.17. ",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  Expanded(
                                    child: Text(
                                        'ANYTIME WORKOUT permits the User to post Material on the Website in accordance with ANYTIME WORKOUT\'s procedures provided that Material is not illegal, obscene, abusive, threatening, defamatory or otherwise objectionable to ANYTIME WORKOUT.'),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Divider(),
                    ListTile(
                      title: const Text('3. Link to third party content',
                          style: TextStyle(fontSize: 14)),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: const <Widget>[
                                    Text("3.1. ",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold)),
                                    Expanded(
                                      child: Text(
                                          'The Site may contain links to websites or applications operated by third parties.We do not have any influence or control over any such third party websites or applications or the third party operator. We are not responsible for and do not endorse any third party websites or applications or their availability or content.'),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: const <Widget>[
                                    Text("3.2. ",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold)),
                                    Expanded(
                                      child: Text(
                                          'We accept no responsibility for adverts contained within the Site. If you agree to purchase goods and/or services from any third party who advertises in the Site, you do so at your own risk. The advertiser, and not us, is responsible for such goods and/or services and if you have any questions or complaints in relation to them, you should contact the advertiser.'),
                                    ),
                                  ],
                                ),
                              ),
                            ]),
                      ),
                    ),
                    const Divider(),
                    ListTile(
                      title: const Text(
                          '4. DISCLAIMER & LIMITATION OF LIABILITY',
                          style: TextStyle(fontSize: 14)),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              const Text(
                                  'The Site and Services are provided on an as-is and as-available basis. You agree that your use of the Site and/or Services will be at your sole risk except as expressly set out in these Terms and Conditions. All warranties, terms, conditions and undertakings, express or implied (including by statute, custom or usage, a course of dealing, or common law) in connection with the Site and Services and your use thereof including, without limitation, the implied warranties of satisfactory quality, fitness for a particular purpose and non-infringement are excluded to the fullest extent permitted by applicable law.'),
                              Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: const <Widget>[
                                    Text("4.1. ",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold)),
                                    Expanded(
                                      child: Text(
                                          'ANYTIME WORKOUT is not liable for any indirect loss, consequential loss, loss of profits, revenue, data or goodwill howsoever arising suffered by any User arising in any way in connection with this Agreement or for any liability of a User to any third party.'),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: const <Widget>[
                                    Text("4.2. ",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold)),
                                    Expanded(
                                      child: Text(
                                          'Whilst ANYTIME WORKOUT will make all reasonable attempts to exclude viruses from the Website, it cannot ensure such exclusion and no liability is accepted for viruses. Thus, the User is recommended to take all appropriate safeguards before downloading information or any Material from the Website.'),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: const <Widget>[
                                    Text("4.4. ",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold)),
                                    Expanded(
                                      child: Text(
                                          'ANYTIME WORKOUT shall not be liable for ensuring that the Material on the Website is not Unacceptable Material and the User in making any financial or other decision accepts that it does so exclusively at its own risk.'),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: const <Widget>[
                                    Text("4.4. ",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold)),
                                    Expanded(
                                      child: Text(
                                          'ANYTIME WORKOUT shall not be liable for any interruption to the Service, whether intentional or otherwise.'),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: const <Widget>[
                                    Text("4.5. ",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold)),
                                    Expanded(
                                      child: Text(
                                          'ANYTIME WORKOUT is not liable for any failure in respect of its obligations here under which result directly or indirectly from failure or interruption in software or services provided by third parties.'),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: const <Widget>[
                                    Text("4.6. ",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold)),
                                    Expanded(
                                      child: Text(
                                          'ANYTIME WORKOUT is not responsible for the direct or indirect consequences of a User linking to any other website from the Website.'),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: const <Widget>[
                                    Text("4.7. ",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold)),
                                    Expanded(
                                      child: Text(
                                          'None of the clauses herein shall apply so as to restrict liability for death or personal injury resulting from the negligence of ANYTIME WORKOUT or its appointed agents.'),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: const <Widget>[
                                    Text("4.8. ",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold)),
                                    Expanded(
                                      child: Text(
                                          'No matter how many claims are made and whatever the basis of such claims, ANYTIME WORKOUT\'s maximum aggregate liability to a User under or in connection with this Agreement in respect of any direct loss (or any other loss to the extent that such loss is not excluded by Clauses 4.1-4.6 above or otherwise) whether such claim arises in contract or in tort shall not exceed a sum equal to twice the value of any amount paid to ANYTIME WORKOUT by the User in relation to which such claim arises.'),
                                    ),
                                  ],
                                ),
                              ),
                            ]),
                      ),
                    ),
                    const Divider(),
                    ListTile(
                      title: const Text('5.WARRANTIES AND INDEMNITY',
                          style: TextStyle(fontSize: 14)),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: const <Widget>[
                                    Text("5.1. ",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold)),
                                    Expanded(
                                      child: Text(
                                          'ANYTIME WORKOUT does not represent or warrant that the information accessible via the Website is accurate, complete or current. ANYTIME WORKOUT has no liability whatsoever in respect of any use which the User makes of such information.'),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: const <Widget>[
                                    Text("5.2. ",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold)),
                                    Expanded(
                                      child: Text(
                                          'Material has not been written to meet the individual requirements of the User and it is the User\'s sole responsibility to satisfy itself prior to entering into any transaction or decision that the Material is suitable for its purposes.'),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: const <Widget>[
                                    Text("5.4. ",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold)),
                                    Expanded(
                                      child: Text(
                                          'All warranties, express or implied, statutory or otherwise are hereby excluded.'),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: const <Widget>[
                                    Text("5.5. ",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold)),
                                    Expanded(
                                      child: Text(
                                          'The User hereby agrees to indemnify ANYTIME WORKOUT against all liabilities, claims and expenses that may arise from any breach of this Agreement by the User.'),
                                    ),
                                  ],
                                ),
                              ),
                            ]),
                      ),
                    ),
                    const Divider(),
                    ListTile(
                      title: const Text('6. GENERAL',
                          style: TextStyle(fontSize: 14)),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: const <Widget>[
                                    Text("6.1. ",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold)),
                                    Expanded(
                                      child: Text(
                                          'Subject to Clause 5.2, this written Agreement and any other expressly incorporated document constitute the entire agreement between the parties hereto relating to the subject matter hereof and neither party has relied on any representation made by the other party unless such representation is expressly included herein. Nothing in this Clause 5.1 shall relieve either party of liability for fraudulent misrepresentations and neither party shall be entitled to any remedy for either any negligent or innocent misrepresentation except to the extent (if any) that a court or arbitrator may allow reliance on the same as being fair and reasonable.'),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: const <Widget>[
                                    Text("6.2. ",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold)),
                                    Expanded(
                                      child: Text(
                                          'ANYTIME WORKOUT reserves the right to alter its terms of business from time to time. The Effective Date at the time the User is reading these terms is set out at the top of this Agreement. Prior to using the Website again in the future, Users should check that the effective date has not altered. If it has, the User should examine the new set of terms and only use the Website if it accepts the new terms.'),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: const <Widget>[
                                    Text("6.4. ",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold)),
                                    Expanded(
                                      child: Text(
                                          'If any provision of this Agreement or part thereof shall be void for whatever reason, it shall be deemed deleted and the remaining provisions shall continue in full force and effect.'),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: const <Widget>[
                                    Text("6.4. ",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold)),
                                    Expanded(
                                      child: Text(
                                          'ANYTIME WORKOUT reserves the right to assign or subcontract any or all of its rights and obligations under this Agreement.'),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: const <Widget>[
                                    Text("6.5. ",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold)),
                                    Expanded(
                                      child: Text(
                                          'The User may not assign or otherwise transfer its rights or obligations under this Agreement without ANYTIME WORKOUT\'s prior written consent.'),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: const <Widget>[
                                    Text("6.6. ",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold)),
                                    Expanded(
                                      child: Text(
                                          'Any notice given pursuant hereto may be served personally or by email to the last known email address of the addressee. It is the responsibility of Users promptly to update ANYTIME WORKOUT of any change of address or email address. Such notice shall be deemed to have been duly served upon and received by the addressee, when served personally, at the time of such service, when sent by email 24 hours after the same shall has been sent, or if sent by post 72 hours after put into the post correctly addressed and pre-paid.'),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: const <Widget>[
                                    Text("6.7. ",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold)),
                                    Expanded(
                                      child: Text(
                                          'ANYTIME WORKOUT shall not be liable for any loss suffered by the other party or be deemed to be in default for any delays or failures in performance here under resulting from acts or causes beyond its reasonable control or from any acts of God, acts or regulations of any governmental or supra-national authority.'),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: const <Widget>[
                                    Text("6.8. ",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold)),
                                    Expanded(
                                      child: Text(
                                          'Any delay or forbearance by ANYTIME WORKOUT in enforcing any provisions of this Agreement or any of its rights here under shall not be construed as a waiver of such provision or right thereafter to enforce the same.'),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: const <Widget>[
                                    Text("6.9. ",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold)),
                                    Expanded(
                                      child: Text(
                                          'The headings in this Agreement are solely used for convenience and shall not have any legal or contractual significance.'),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: const <Widget>[
                                    Text("6.10. ",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold)),
                                    Expanded(
                                      child: Text(
                                          'This Agreement shall be governed by and construed in accordance with the laws of Dubai, and the parties submit to the non-exclusive jurisdiction of the Courts of Dubai, save that ANYTIME WORKOUT may take action in any relevant jurisdiction to enforce its Intellectual Property Rights.'),
                                    ),
                                  ],
                                ),
                              ),
                            ]),
                      ),
                    ),
                    const Divider(),
                    ListTile(
                      title: const Text(
                          '7. Modifications to and availability of the Site',
                          style: TextStyle(fontSize: 14)),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: const <Widget>[
                                    Text("7.1. ",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold)),
                                    Expanded(
                                      child: Text(
                                          'We reserve the right to change, modify, or remove the contents of the Site at any time or for any reason at our sole discretion without notice. We also reserve the right to modify or discontinue all or part of the Services without notice at any time.'),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: const <Widget>[
                                    Text("7.2. ",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold)),
                                    Expanded(
                                      child: Text(
                                          'We cannot guarantee the Site and Services will be available at all times. We may experience hardware, software, or other problems or need to perform maintenance related to the Site, resulting in interruptions, delays, or errors. You agree that we have no liability whatsoever for any loss, damage, or inconvenience caused by your inability to access or use the Site or Services during any downtime or discontinuance of the Site or Services.We are not obliged to maintain and support the Site or Services or to supply any corrections, updates, or releases.'),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: const <Widget>[
                                    Text("7.3. ",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold)),
                                    Expanded(
                                      child: Text(
                                          'There may be information on the Site that contains typographical errors, inaccuracies, or omissions that may relate to the Services, including descriptions, pricing, availability, and various other information. We reserve the right to correct any errors, inaccuracies, or omissions and to change or update the information at any time, without prior notice.'),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 10, top: 5),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: const <Widget>[
                                    Expanded(
                                      child: Text(
                                          'In order to resolve a complaint regarding the Services or to receive further information regarding use of the Services, please contact us.'),
                                    ),
                                  ],
                                ),
                              ),
                            ]),
                      ),
                    ),
                    const Divider(),
                  ]),
                )));
      }),
    );
  }
}
