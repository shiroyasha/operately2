import * as React from "react";
import * as People from "@/models/people";

import FormattedTime from "@/components/FormattedTime";

import { Container } from "../FeedItemElements";
import { Link } from "@/components/Link";
import { Summary } from "@/components/RichContent";

import * as Time from "@/utils/time";

export default function ({ activity }) {
  const content = activity.content;
  const update = content.update;
  const comment = content.comment;
  const project = content.projectId;

  const insertedAt = Time.parseISO(update.insertedAt);
  const time = <FormattedTime time={insertedAt} format="long-date" />;

  const path = `/projects/${project.id}/status_updates/${update.id}`;
  const link = <Link to={path}>Check-In on {time}</Link>;
  const title = (
    <>
      {People.shortName(activity.author)} commented on: {link}
    </>
  );

  const commentMessage = JSON.parse(comment.message);

  const summary = <Summary jsonContent={commentMessage} characterCount={200} />;

  return <Container title={title} author={activity.author} time={activity.insertedAt} content={summary} />;
}