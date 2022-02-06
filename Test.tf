func TestFlattenSecurityGroups(t *testing.T) {
    cases := []struct {
        ownerId  *string
        pairs    []*ec2.UserIdGroupPair
        expected []*GroupIdentifier
    }{
        // simple, no user id included
        {
            ownerId: aws.String("user1234"),
            pairs: []*ec2.UserIdGroupPair{
                &ec2.UserIdGroupPair{
                    GroupId: aws.String("sg-12345"),
                },
            },
            expected: []*GroupIdentifier{
                &GroupIdentifier{
                    GroupId: aws.String("sg-12345"),
                },
            },
        },
        // include the owner id, but keep it consitent with the same account. Tests
        // EC2 classic situation
        {
            ownerId: aws.String("user1234"),
            pairs: []*ec2.UserIdGroupPair{
                &ec2.UserIdGroupPair{
                    GroupId: aws.String("sg-12345"),
                    UserId:  aws.String("user1234"),
                },
            },
            expected: []*GroupIdentifier{
                &GroupIdentifier{
                    GroupId: aws.String("sg-12345"),
                },
            },
        },

        // include the owner id, but from a different account. This is reflects
        // EC2 Classic when referring to groups by name
        {
            ownerId: aws.String("user1234"),
            pairs: []*ec2.UserIdGroupPair{
                &ec2.UserIdGroupPair{
                    GroupId:   aws.String("sg-12345"),
                    GroupName: aws.String("somegroup"), // GroupName is only included in Classic
                    UserId:    aws.String("user4321"),
                },
            },
            expected: []*GroupIdentifier{
                &GroupIdentifier{
                    GroupId:   aws.String("sg-12345"),
                    GroupName: aws.String("user4321/somegroup"),
                },
            },
        },
    }

    for _, c := range cases {
        out := flattenSecurityGroups(c.pairs, c.ownerId)
        if !reflect.DeepEqual(out, c.expected) {
            t.Fatalf("Error matching output and expected: %#v vs %#v", out, c.expected)
        }
    }
}